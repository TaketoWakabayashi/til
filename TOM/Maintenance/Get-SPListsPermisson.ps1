#SetParameter
$siteUrl = "http://sps2013/sites/tomv2/"
$outfilename = "$PSScriptRoot\Output\ListsPermission.txt"

# Load the SharePoint .NET Framework Client Object Model libraries. 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.Runtime.dll"

function Invoke-LoadMethod() {
    param(
        [Microsoft.SharePoint.Client.ClientObject]$Object = $(throw "Please provide a Client Object"),
        [string]$PropertyName
    ) 
    $ctx = $Object.Context
    $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load") 
    $type = $Object.GetType()
    $clientLoad = $load.MakeGenericMethod($type) 
  
  
    $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
    $Expression = [System.Linq.Expressions.Expression]::Lambda(
        [System.Linq.Expressions.Expression]::Convert(
            [System.Linq.Expressions.Expression]::PropertyOrField($Parameter, $PropertyName),
            [System.Object]
        ),
        $($Parameter)
    )
    $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
    $ExpressionArray.SetValue($Expression, 0)
    $clientLoad.Invoke($ctx, @($Object, $ExpressionArray))
}

function WriteToFile($text, $append) {
    $sw = New-Object System.IO.StreamWriter($outfilename, $append, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
    try {
        $sw.WriteLine($text)
    }
    finally {
        $sw.Dispose()
    }
}

function GetObjectRoles($obj, $url) {
    $context.Load($obj.RoleAssignments)
    Invoke-LoadMethod -Object $obj -PropertyName "HasUniqueRoleAssignments"
    $context.ExecuteQuery()
    foreach ($ra in $obj.RoleAssignments) {
        $sb = new-object System.Text.StringBuilder
        $cnt = $sb.Append($obj.title)
        $cnt = $sb.Append("`t")
        $cnt = $sb.Append($url)
        $cnt = $sb.Append("`t")
        $cnt = $sb.Append($obj.HasUniqueRoleAssignments)
        $cnt = $sb.Append("`t")  
        $context.Load($ra.Member)
        $context.ExecuteQuery()
        $cnt = $sb.Append($ra.Member.Title)
        $cnt = $sb.Append("`t") 
        $context.Load($ra.RoleDefinitionBindings)
        $context.ExecuteQuery()
        foreach ($rd in $ra.RoleDefinitionBindings) {
            $cnt = $sb.Append($rd.Name) 
            $cnt = $sb.Append(",") 
        }
        WriteToFile -text $sb.ToString() -append $true
    }
}

function GetWebObjectRoles($inweb, $url) {
    GetObjectRoles -obj $inweb -url $url
    $lists = $inweb.Lists
    $context.Load($lists)
    $context.ExecuteQuery()

    foreach ($list in $lists) {
        $context.Load($list)
        $context.Load($list.RootFolder)
        $context.ExecuteQuery()
        if ($list.Hidden -ne $true) {
            $url = $inweb.Url + $list.RootFolder.ServerRelativeUrl
            if ($inweb.Url.EndsWith($inweb.ServerRelativeUrl)) {
                $url = $inweb.Url.Replace($inweb.ServerRelativeUrl, "") + $list.RootFolder.ServerRelativeUrl
            }
            GetObjectRoles -obj $list -url $url
        }
    }
  
    $webs = $inweb.Webs
    $context.Load($webs)
    $context.ExecuteQuery()
    foreach ($aweb in $webs) {
        $context.Load($aweb)
        $context.ExecuteQuery()
        if ($aweb.Hidden -ne $true) {
            GetWebObjectRoles -inweb $aweb -url $aweb.Url
        }
    }
}


function GetAllWebObjects() {
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
    $rootweb = $context.Web
    $context.Load($rootweb)
    $context.ExecuteQuery()
    WriteToFile -text "Title`tURL`tHasUniqueRoleAssignments`tUser/Group`tRoles" -append $false
    GetWebObjectRoles -inweb $rootweb -url $rootweb.Url
}

GetAllWebObjects