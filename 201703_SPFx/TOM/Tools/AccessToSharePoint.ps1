#-----------------------------------------------------------------------------------------------------------------------------------------------#
# 環境設定
#-----------------------------------------------------------------------------------------------------------------------------------------------#
# Connect to Access Database.
$path = Split-Path $MyInvocation.MyCommand.Path -Parent
$path = Join-Path $path "test.accdb"
$connectionString = "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = $path"
$adOpenStatic = 3
$adLockOptimistic = 3
$con = New-Object -ComObject ADODB.Connection
$rs = New-Object -ComObject ADODB.Recordset

# Load the SharePoint 2013 .NET Framework Client Object Model libraries. 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "$PSScriptRoot\Modules\Microsoft.SharePoint.Client.Runtime.dll"

# Authenticate with the SharePoint Online site. 
$siteUrl = “https://pwcmsj.sharepoint.com/sites/TOM-TW”
$inputpassword = "Mich@el0wen628"
$password = ConvertTo-SecureString -String $inputpassword -AsPlainText -Force
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("taketo.wakabayashi@pwcmsj.onmicrosoft.com", $password) 
$ctx.Credentials = $credentials
#-----------------------------------------------------------------------------------------------------------------------------------------------#

# データベース接続をオープン
$con.Open($connectionString)

# レコードセットをオープン
$rs.Open("SELECT * FROM [【LegalEntities】SelectInsertRecords(temp)]", $con, $adOpenStatic, $adLockOptimistic)

# 先頭行に移動
$rs.MoveFirst()

# レコードセットの最後までループ
While ($rs.EOF -eq $false) {

    # レコードの情報を元に、SharePointグループを追加
    $ctx.Load($ctx.Web.SiteGroups)
    $ctx.ExecuteQuery()
    $sNewGroup = New-Object Microsoft.SharePoint.Client.GroupCreationInformation
    $sNewGroup.Title = $rs.Fields.Item("タイトル").Value
    $sNewGroup = $ctx.Web.SiteGroups.Add($sNewGroup)
    $ctx.Load($sNewGroup);
    $ctx.ExecuteQuery();

   # 次のレコードに移動する
   $rs.MoveNext()
}

# レコードセットを閉じる
$rs.Close()

# 接続を閉じる
$con.Close()

# COM オブジェクトをリリース
[void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($rs)
[void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($con)