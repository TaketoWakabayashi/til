Add-Type -Path "C:\temp\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\temp\Microsoft.SharePoint.Client.Runtime.dll"

$siteURL = "https://pwcmsj.sharepoint.com/sites/tom004"
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)

$userId = "tomadmin01@pwcmsj.onmicrosoft.com"
$pwd = Read-Host -Prompt "Enter password" -AsSecureString  
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId, $pwd)  
$ctx.credentials = $creds  
$ctx.credentials = $creds  

$web = $ctx.Site.OpenWeb("")
$list = $web.Lists.GetByTitle("WList")
$list2 = $web.Lists.GetByTitle("Daily Mail Notification List")

$query = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery()  
$listItems = $list.GetItems($query)  
$ctx.Load($listItems)
$ctx.ExecuteQuery()

$listItems2 = $list2.GetItems($query)  
$ctx.Load($listItems2)
$ctx.ExecuteQuery()

$today = Get-Date

$itemCreateinfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$itemCreatelist = $list2.AddItem($itemCreateinfo)
#$csv = Import-Csv "c:\temp\permission.csv"

# Set Permissions  
    foreach($listItem in $listItems){
        foreach($listItem2 in $listItems2){
            if ($listItem.FieldValues.Title -eq $listItem2.FieldValues.Title){
                if ($listItem2.FieldValues.StartSendFlag -ne 1) {
                    $startdate = $listItem.FieldValues.Start_x0020_Date
                    $duration = New-TimeSpan $startdate $today
                    if ($duration.Days -gt -1) {
                        #$listItem2.FieldValues.N = "1"
                        #$listItem2.FieldValues.StartSendFlag ="1"
                        #$listitem2.Update()
                        $ListItemID = $listItem2.Id
                        $listItem3 = $listItems2.GetById($ListItemID)
                        $listItem3["N"] = "1"
                        $listItem3["StartSendFlag"] = "1"
                        $listItem3.Update()
                        $ctx.ExecuteQuery()  
                    }
                }
                if ($listItem2.FieldValues.StartSendFlag -eq 1) {
                    if ($listItem2.FieldValues.DueNotSendFlag -ne 1) {
                        if ($listItem.FieldValues.TOM_WIStatus -ne "Complete"){
                            $duedate = $listItem.FieldValues.Due_x0020_Date
                            $duration2 = New-TimeSpan $duedate $today
                            if ($duration2.Days -gt -5) {
                                $ListItemID = $listItem2.Id
                                $listItem3 = $listItems2.GetById($ListItemID)
                                $listItem3["N"] = "2"
                                $listitem3.Update()
                                $ctx.ExecuteQuery()  
                            }
                        }
                        if ($listItem.FieldValues.TOM_WIStatus -eq "Complete"){
                            $listItem3["DueNotSendFlag"] = "1"
                            $listitem3.Update()
                            $ctx.ExecuteQuery()  
                        }
                    }
                }
      
            }
        }
    }  
    