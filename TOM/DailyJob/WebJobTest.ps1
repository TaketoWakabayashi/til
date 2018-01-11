# Load the SharePoint 2013 .NET Framework Client Object Model libraries. 
Add-Type –Path "Microsoft.SharePoint.Client.dll" 
Add-Type –Path "Microsoft.SharePoint.Client.Runtime.dll"

# Authenticate with the SharePoint Online site. 
$siteUrl = “https://pwcmsj.sharepoint.com/sites/TOM-TW”
$inputpassword = "Mich@el0wen628"
$password = ConvertTo-SecureString -String $inputpassword -AsPlainText -Force
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("taketo.wakabayashi@pwcmsj.onmicrosoft.com", $password) 
$ctx.Credentials = $credentials

# Create list item. 
$list = $ctx.get_web().get_lists().getByTitle('Announcement'); 
$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation 
$listItem = $list.addItem($itemCreateInfo); 
$now = (Get-Date).ToString("yyyyMMddHHmmss")
$listItem.set_item('Title', 'My New Item by PS1! ' + $now); 
$listItem.set_item('Body', 'Hello World by PS1! ' + $now); 
$listItem.update(); 
$ctx.Load($listItem) 
$ctx.ExecuteQuery()