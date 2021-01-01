#SetParameter
$siteUrl = "http://sps2013/sites/tomv2/"
$LibraryName = "TaxDocuments"
$outfilename = "$PSScriptRoot\Output\LibraryItemsPermission.txt"

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
    $context.ExecuteQuery()
    foreach ($ra in $obj.RoleAssignments) {
        $sb = new-object System.Text.StringBuilder
        $cnt = $sb.Append($obj.Title)
        $cnt = $sb.Append("`t") 
        $cnt = $sb.Append($url)
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

function GetItemRoles($obj) {
    $context.Load($obj.RoleAssignments)
    $context.Load($obj.File)
    $context.Load($obj.Folder)
    Invoke-LoadMethod -Object $obj -PropertyName "HasUniqueRoleAssignments"
    $context.ExecuteQuery()
    foreach ($ra in $obj.RoleAssignments) {
        $sb = new-object System.Text.StringBuilder
        $cnt = $sb.Append($obj["ID"])
        $cnt = $sb.Append("`t") 
        if ($obj.File.Name -ne $null) {
            $cnt = $sb.Append($obj.File.Name)
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append($obj.File.ServerRelativeUrl)
            $cnt = $sb.Append("`t")
        }
        else {
            $cnt = $sb.Append($obj.Folder.Name)
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append($obj.Folder.ServerRelativeUrl)
            $cnt = $sb.Append("`t")
        }
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

function GetListObjectRoles($inlist, $url) {
    GetObjectRoles -obj $inlist -url $url
    WriteToFile -text "" -append $true

    $listItems = $inlist.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
    $context.load($listItems)
    $context.executeQuery()
    WriteToFile -text "-----LibraryItems-----" -append $true
    WriteToFile -text "ID`tTitle`tPath`tHasUniqueRoleAssignments`tUser/Group`tRoles" -append $true

    foreach ($listItem in $listItems) {
        $context.Load($listItem)
        $context.ExecuteQuery()
        GetItemRoles -obj $listItem
    }
}

function GetAllListObjects() {
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

    $rootlist = $context.web.Lists.GetByTitle($LibraryName)
    $context.Load($rootlist)
    $context.Load($rootlist.RootFolder)
    $context.ExecuteQuery()
  
    $listUrl = $siteUrl + $rootlist.RootFolder.ServerRelativeUrl.Remove(0, 1)

    WriteToFile -text "-----TargetLibrary-----" -append $false
    WriteToFile -text "Title`tURL`tUser/Group`tRoles" -append $true
    GetListObjectRoles -inlist $rootlist -url $listUrl
}

GetAllListObjects