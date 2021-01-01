Add-PSSnapin Microsoft.SharePoint.PowerShell
#Adding the Client OM Assemblies        
Add-Type -Path "Microsoft.SharePoint.Client.dll"
Add-Type -Path "Microsoft.SharePoint.Client.Runtime.dll"

$web = Get-SPWeb "https://pwcmsj.sharepoint.com/sites/TOM-TW/"
$list = $web.Lists["BingMapList"]
$list.Fields.AddFieldAsXml( "", $true, [Microsoft.SharePoint.SPAddFieldOptions]::AddFieldToDefaultView)