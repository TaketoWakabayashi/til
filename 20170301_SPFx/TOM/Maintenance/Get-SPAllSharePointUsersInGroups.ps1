#SetParameter
$siteUrl = "http://sps2013/sites/tomv2/"
$outfilename = "$PSScriptRoot\Output\SPGroupList.txt"

# Load the SharePoint .NET Framework Client Object Model libraries. 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.Runtime.dll"

function WriteToFile($text, $append) {
    $sw = New-Object System.IO.StreamWriter($outfilename, $append, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
    try {
        $sw.WriteLine($text)
    }
    finally {
        $sw.Dispose()
    }
}

#Definition of the function that gets all the SharePoint groups and Users per Group in a SharePoint site
function Get-SPAllSharePointUsersInGroups {
    param ($siteUrl)
    try {    
        $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 

        #Root Web Site
        $rootweb = $context.Web

        #Collecction of Sites under the Root Web Site
        $spSites = $rootweb.Webs

        #Loading Operations
        $spGroups = $context.Web.SiteGroups
        $context.Load($spGroups)
        $context.ExecuteQuery()       
        
        #We need to iterate through the $spGroups Object in order to get individual Group information
        foreach ($spGroup in $spGroups) {
            $context.Load($spGroup)
            $context.ExecuteQuery()

            $sb = new-object System.Text.StringBuilder
            $cnt = $sb.Append($spGroup.Title)
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append($spGroup.OwnerTitle)
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append("-")
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append("-")
            $cnt = $sb.Append("`t")
            $cnt = $sb.Append("-")
            $cnt = $sb.Append("`t") 
            $cnt = $sb.Append($spUser.LoginName )
            WriteToFile -text $sb.ToString() -append $true

            #Getting the users per group in the SharePoint
            $spSiteUsers = $spGroup.Users
            $context.Load($spSiteUsers)
            $context.ExecuteQuery()

            foreach ($spUser in $spSiteUsers) {
                $sb = new-object System.Text.StringBuilder
                $cnt = $sb.Append($spGroup.Title)
                $cnt = $sb.Append("`t")
                $cnt = $sb.Append($spGroup.OwnerTitle)
                $cnt = $sb.Append("`t")
                $cnt = $sb.Append($spUser.Title)
                $cnt = $sb.Append("`t")
                $cnt = $sb.Append($spUser.Id)
                $cnt = $sb.Append("`t")
                $cnt = $sb.Append($spUser.Email)
                $cnt = $sb.Append("`t") 
                $cnt = $sb.Append($spUser.LoginName )
                WriteToFile -text $sb.ToString() -append $true               
            }
        }
        $context.Dispose()
    }
    catch [System.Exception] {
        write-host -f red $_.Exception.ToString()   
    }    
}

WriteToFile -text "SPGroup`tGroupOwner`tTitle`tID`tEmail`tLoginName" -append $false
Get-SPAllSharePointUsersInGroups -siteUrl $siteUrl