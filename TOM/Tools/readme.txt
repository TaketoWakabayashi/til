【実装要件】
・作業者は[サイトの所有者]レベル
    ※サイトコレクションの管理者権限は持っていない

・Input Dataは、[ROOTS]及び[Office 365]から出力されるCSVを想定

・[ROOTS]出力データは、以下を想定
    会社/管掌部署等の一覧（IDは付与されていない）

・Office 365出力データは、以下を想定
    Office 365でエクスポート可能な、[ユーザ一覧]
    ※所属グループ情報を保持している

・差分情報の出力は想定しない。（最新のフル情報のみ）


【Tool候補】
・Access
・PowerShell(CSOM)
・Microsoft Flow
・PowerApps
