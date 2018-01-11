#SetParameter
$siteURL = "https://pwcmsj.sharepoint.com/sites/TOM-TW/"
#$outfilename = "$PSScriptRoot\Output\SPGroupList.txt"

# Load the SharePoint .NET Framework Client Object Model libraries. 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.Runtime.dll"

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)

$userId = "taketo.wakabayashi@pwcmsj.onmicrosoft.com"
$pwd = Read-Host -Prompt "Enter password" -AsSecureString  
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId, $pwd)  
$ctx.credentials = $creds  

$web = $ctx.Site.OpenWeb("")
$list = $web.Lists.GetByTitle("Announcement")
