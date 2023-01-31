# SharePoint Framework
## [開発環境のセットアップ](https://docs.microsoft.com/ja-jp/sharepoint/dev/spfx/set-up-your-development-environment)
* Node.js
* VScode
* Yeoman, Glup
* SharePoint Framework Yeoman ジェネレーター

## [ツールチェーン](https://docs.microsoft.com/ja-jp/sharepoint/dev/spfx/toolchain/sharepoint-framework-toolchain)

### [Yeoman](http://www.atmarkit.co.jp/ait/articles/1407/02/news040.html)
`yo`, `Grunt`, `Bower`で構成、されているWeb作業効率化ツール

* yo・・・Webページのテンプレートを生成(様々なアプリに対応、Sharepointのテンプレートも提供されている)
* Grunt・・・JavaScriptベースのタスクランナー。製作用Webサーバの立ち上げ、リリースビルドなどの製作を支援
* Bower・・・JavaScriptライブラリ、CSSフレームワークなどのパッケージマネージャ

それぞれ疎結合で連携しているため、ツールの代替も可能。（例 Grunt → Gulp等）

### TypeScript
* Microsoft エンジニア

## Web Parts & Extension
### Web Parts
* 従来のWeb Partsと同様、SharePointのページに埋め込んで利用

### Extention
* `Application Customizer`, `Field Customizer`, `ListView Command Set`という3種類のテンプレートが用意されている。
* Application Customizer ・・・ モダンページ、リスト、ライブラリに対して統一的に適用されるデザイン（`Site`, `Web`, `List`のスコープで制御することも可能）
* Field Customizer ・・・ リストに追加可能な`サイト列`として登録される
* ListView Command Set ・・・ 

## [SPOへのデプロイの流れ](https://docs.microsoft.com/ja-jp/sharepoint/dev/spfx/web-parts/get-started/serve-your-web-part-in-a-sharepoint-page)
* yo @microsoft/sharepoint ・・・ Microsoftが提供するSharePoint Frameworkの展開
* gulp serve ・・・ ローカル展開実行(--nobrowserオプションをつけることで、ブラウザ実行を回避可能)  
※SPOサイトのワークベンチで動作確認したい場合、/_layout/15/workbench.aspxを活用することができる。
* gulp bundle ・・・ (--shipオプションをつけることで、SPOにホストさせることができる)
* gulp package-solution ・・・ パッケージ作成(--shipオプションをつけることで、SPOにホストさせることができる)

