■概要
・共通事項
　「Modules」フォルダには、参照するDLLを格納しています。
　「Output」フォルダには、スクリプトを実行した際の出力データがテキスト形式で格納されます。
　出力データは、各フィールドがタブ区切りとなっており、Excelのフィルター機能等を利用して活用することを想定した形式としています。

・Get-SPAllSharePointUsersInGroups.ps1
　対象のサイトコレクションのSharePointグループに所属するユーザー一覧を取得するスクリプト
　
・Get-SPListsPermisson.ps1
　対象のサイトコレクションに格納されている全てのリストに対する権限を出力するスクリプト（再帰的にサブサイトも読み込み）
　フォルダ、アイテムレベルでの権限は出力しない

・Get-SPLibraryItemsPermission.ps1
　対象のライブラリに格納されている全てのフォルダ/アイテムに対する権限を出力するスクリプト(再帰的にフォルダ内のアイテムも読み込み)

・Get-SPListItemsPermission.ps1
　対象のリストに格納されている全てのフォルダ/アイテムに対する権限を出力するスクリプト(再帰的にフォルダ内のアイテムも読み込み)

■使い方
1. 各スクリプトの一番上に記載されている下記パラメータを環境に合わせて変更します。

　$siteUrl：対象サイトコレクションのURL
　$outfilename：出力ファイルパスとファイル名（デフォルトのままでも使えます）
　$LibraryName：対象のライブラリ名　※Get-SPLibraryItemsPermission.ps1のみ
　$ListName：対象のリスト名　※Get-SPListItemsPermission.ps1のみ


2. 「Maintenance」フォルダごと実行するサーバーにコピペし（貼り付け先は任意）、各スクリプトを実行します。