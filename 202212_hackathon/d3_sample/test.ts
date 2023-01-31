//
// 以下のページで詳細を解説しています
// https://qiita.com/alclimb/items/31d4360c74a8f8935256
//

import * as d3 from 'd3';

// GeoJsonファイルを読み込み
import geoJson from '~/assets/japan.geo.json';

async function main() {
    const width = 400; // 描画サイズ: 幅
    const height = 400; // 描画サイズ: 高さ
    const centerPos = [137.0, 38.2]; // 地図のセンター位置
    const scale = 1000; // 地図のスケール

    // 地図の投影設定
    const projection = d3
        .geoMercator()
        .center(centerPos)
        .translate([width / 2, height / 2])
        .scale(scale);

    // 地図をpathに投影(変換)
    const path = d3.geoPath().projection(projection);

    // SVG要素を追加
    const svg = d3
        .select(`#map-container`)
        .append(`svg`)
        .attr(`viewBox`, `0 0 ${width} ${height}`)
        .attr(`width`, `100%`)
        .attr(`height`, `100%`);

    //
    // [ メモ ]
    // 動的にGeoJsonファイルを読み込む場合は以下のコードを使用
    // const geoJson = await d3.json(`/japan.geo.json`);
    //

    // 都道府県の領域データをpathで描画
    svg
        .selectAll(`path`)
        .data(geoJson.features)
        .enter()
        .append(`path`)
        .attr(`d`, path)
        .attr(`stroke`, `#666`)
        .attr(`stroke-width`, 0.25)
        .attr(`fill`, `#2566CC`)
        .attr(`fill-opacity`, (item: any) => {
            // メモ
            // item.properties.name_ja に都道府県名が入っている

            // 透明度をランダムに指定する (0.0 - 1.0)
            return Math.random();
        })

        /**
         * 都道府県領域の MouseOver イベントハンドラ
         */
        .on(`mouseover`, function (item: any) {
            // ラベル用のグループ
            const group = svg.append(`g`).attr(`id`, `label-group`);

            // 地図データから都道府県名を取得する
            const label = item.properties.name_ja;

            // 矩形を追加: テキストの枠
            const rectElement = group
                .append(`rect`)
                .attr(`id`, `label-rect`)
                .attr(`stroke`, `#666`)
                .attr(`stroke-width`, 0.5)
                .attr(`fill`, `#fff`);

            // テキストを追加
            const textElement = group
                .append(`text`)
                .attr(`id`, `label-text`)
                .text(label);

            // テキストのサイズから矩形のサイズを調整
            const padding = { x: 5, y: 0 };
            const textSize = textElement.node().getBBox();
            rectElement
                .attr(`x`, textSize.x - padding.x)
                .attr(`y`, textSize.y - padding.y)
                .attr(`width`, textSize.width + padding.x * 2)
                .attr(`height`, textSize.height + padding.y * 2);

            // マウス位置の都道府県領域を赤色に変更
            d3.select(this).attr(`fill`, `#CC4C39`);
            d3.select(this).attr(`stroke-width`, `1`);
        })

        /**
         * 都道府県領域の MouseMove イベントハンドラ
         */
        .on('mousemove', function (item: any) {
            // テキストのサイズ情報を取得
            const textSize = svg.select('#label-text').node().getBBox();

            // マウス位置からラベルの位置を指定
            const labelPos = {
                x: d3.event.offsetX - textSize.width,
                y: d3.event.offsetY - textSize.height,
            };

            // ラベルの位置を移動
            svg
                .select('#label-group')
                .attr(`transform`, `translate(${labelPos.x}, ${labelPos.y})`);
        })

        /**
         * 都道府県領域の MouseOut イベントハンドラ
         */
        .on(`mouseout`, function (item: any) {
            // ラベルグループを削除
            svg.select('#label-group').remove();

            // マウス位置の都道府県領域を青色に戻す
            d3.select(this).attr(`fill`, `#2566CC`);
            d3.select(this).attr(`stroke-width`, `0.25`);
        });

    //都市　位置情報
    var pointdata = {
        type: 'LineString',
        coordinates: [
            [139.69170639999993, 35.6894875], //東京
            [135.49602571365457, 34.70269692288335], //大阪
        ],
    };

    //都市間ライン追加
    var line = svg
        .selectAll('.line')
        .data([pointdata])
        .enter()
        .append('path')
        .attr({
            class: 'line',
            d: path,
            fill: 'none',
            stroke: 'red',
            'stroke-width': 1.5,
        });

    //都市ポイント追加
    var point = svg
        .selectAll('.point')
        .data(pointdata.coordinates)
        .enter()
        .append('circle')
        .attr({
            cx: function (d) {
                return projection(d)[0];
            },
            cy: function (d) {
                return projection(d)[1];
            },
            r: 6,
            fill: 'red',
            'fill-opacity': 1,
        });
}

main();
