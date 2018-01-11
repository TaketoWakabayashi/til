# 変数の宣言
$adOpenStatic = 3
$adLockOptimistic = 3
$con = New-Object -ComObject ADODB.Connection
$rs = New-Object -ComObject ADODB.Recordset

# スクリプトのカレントディレクトリを取得
$path = Split-Path $MyInvocation.MyCommand.Path -Parent

# スクリプトのカレントディレクトリのデータベースパスを作成
$path = Join-Path $path "test.accdb"  # test.accdb も可

# データベース接続文字列の指定
$connectionString = "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = $path"

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

# データベース接続をオープン
$con.Open($connectionString)

# レコードセットをオープン
$rs.Open("SELECT * FROM [【AddressList】SelectInsertRecords]", $con, $adOpenStatic, $adLockOptimistic)

# 先頭行に移動
$rs.MoveFirst()

# レコードセットの最後までループ
While ($rs.EOF -eq $false) {

    # レコードの情報を元に、SharePointリストにアイテムを追加
    $list = $ctx.get_web().get_lists().getByTitle('AddressList')
    $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $listItem = $list.addItem($itemCreateInfo)
    $listItem.set_item('_xfeff__x8868__x793a__x540d_', $rs.Fields.Item("表示名").Value)
    $listItem.set_item('_x30d7__x30e9__x30a4__x30de__x30', $rs.Fields.Item("プライマリ メール アドレス").Value)
    $listItem.update()
    $ctx.Load($listItem)
    $ctx.ExecuteQuery()

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