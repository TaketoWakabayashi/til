import { Version } from '@microsoft/sp-core-library';
import {
  BaseClientSideWebPart,
  IPropertyPaneConfiguration,
  PropertyPaneTextField
} from '@microsoft/sp-webpart-base';
import { escape } from '@microsoft/sp-lodash-subset';

import styles from './ImageAnalyzerWebPart.module.scss';
import * as strings from 'ImageAnalyzerWebPartStrings';
//import MockHttpClient from './SaveImageToAzureStorage';

export interface IImageAnalyzerWebPartProps {
  description: string;
}

export default class ImageAnalyzerWebPart extends BaseClientSideWebPart<IImageAnalyzerWebPartProps> {

  public render(): void {
    this.domElement.innerHTML = `
      <div class="${ styles.imageAnalyzer}">
        <div class="${ styles.container}">
          <div class="${ styles.row}">
            <div class="${ styles.column}">
              <span class="${ styles.title}">AIとBIを使ったアプリケーション開発</span>
              <p class="${ styles.subTitle}">このアプリケーションは、アップロードされた画像ファイルを一定時間毎に解析し文字情報を抽出します。</p>
              <form name="myform">
                <input name="myfile" type="file" />
              </form>
              <p class="${ styles.description}">${escape(this.properties.description)}</p>
              <img id="img" />
            </div>
          </div>
        </div>
      </div>`;
  }

  protected get dataVersion(): Version {
    return Version.parse('1.0');
  }

  protected getPropertyPaneConfiguration(): IPropertyPaneConfiguration {
    return {
      pages: [
        {
          header: {
            description: strings.PropertyPaneDescription
          },
          groups: [
            {
              groupName: strings.BasicGroupName,
              groupFields: [
                PropertyPaneTextField('description', {
                  label: strings.DescriptionFieldLabel
                })
              ]
            }
          ]
        }
      ]
    };
  }
}
