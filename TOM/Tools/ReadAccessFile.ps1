#
#  PowerShell から ADO でレコードを読み込む
#


# 変数の宣言
$adOpenStatic = 3
$adLockOptimistic = 3
$con = New-Object -ComObject ADODB.Connection
$rs = New-Object -ComObject ADODB.Recordset

# スクリプトのカレントディレクトリを取得
$path = Split-Path $MyInvocation.MyCommand.Path -Parent

# スクリプトのカレントディレクトリのデータベースパスを作成
$path = Join-Path $path "test.accdb"  # test.accdb も可

# 接続文字列の指定
$connectionString = "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = $path"

# 接続をオープン
$con.Open($connectionString)

# レコードセットをオープン
$rs.Open("SELECT * FROM [AddressList(CSV)]", $con, $adOpenStatic, $adLockOptimistic) 

# 先頭行に移動
$rs.MoveFirst()

# レコードセットの最後までループ
While ($rs.EOF -eq $false) {
   # フィールドの値を連結して出力
   Write-Host $rs.Fields.Item("表示名").Value : $rs.Fields.Item("プライマリ メールアドレス").Value 
   
   # 次のレコードに移動する
   $rs.MoveNext()
}

# レコードセットを閉じる
$rs.Close()

# 接続を閉じる
$con.Close()

# COM オブジェクトをリリース(Excelと違ってなくても問題ないけど一応)
[void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($rs)
[void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($con)