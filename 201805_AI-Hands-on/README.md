# [ハンズオン]AIとBIを使ったアプリケーション開発(AI + BI Cognitive + DB/Cosmos + BI)

## 環境情報
### ResourceGroup : AI_Hands-on
### HO_ComVision
* endpoint : https://eastasia.api.cognitive.microsoft.com/vision/v1.0
* key1 : caa868a49f2f4f0f80dc969dbe9b863a
* key2 : 9ce1befa405649879a65a5d3172d1b76

### HO_TranslaterText
* endpoint : https://api.cognitive.microsoft.com/sts/v1.0
* key1 : e29fd7bfc0a74d26a82b28d0ce77ee07
* key2 : 4db2992472134b858ab6b86cd344aaf4

### hostorageaccount(汎用v2)
* key1 : 3Wve9VFUgbY+5A+YzlD5DpeDyQxTh+MIRtLhWUqYAN8NpcNEFucEqiR07oJjBZ0sGpuDz6j5N0YTNOI2+vUJYA==
* key2 : mHGPVhSl32LKuCgzR87giwZcT8WktKA4MXLlQUu/z/iNejnj3xcfdO7z3Da4h6jLvpmI/lzGEU0hPy6VZafmRQ==
* BlobServiceEndpoint : https://hostorageaccount.blob.core.windows.net/

### ho-cosmosdb(SQL API)
* サブスクリプションID : 6ebed71b-c079-47c8-9632-49fca92aef78
* URI : https://ho-cosmosdb.documents.azure.com:443/
* readkey1 : pBiGwPDI11ExPdiwjQvsYaVisb4I8xnY19LvYEWwspuiIqI0eT3RZTDgY23FIyK84Mj3y4JzuT8J2BKs90cKog==
* readkey2 : mnelIMzxMiKqBUtLKzs5sHXqwDfJvPSHqnINtpY03sWxwtFEBx0zhxGz5ObiIcyBT0ZscVNCOxINIRVp3yRVXg==
* Database ID : Adventureworks
* Collection ID : feedbacks

# Cognitive Services
## APIの種類
* Face API : 性別、年齢、属性、
* Emotion API : 感情
* Computervision API : 画像分析
* Translator API : 機械翻訳  

## 利用方法
* AzureにAPIをサービスとして登録して、生成されるサービスのエンドポイント・キーを利用してアクセス
* https://docs.microsoft.com/en-us/azure/cognitive-services/