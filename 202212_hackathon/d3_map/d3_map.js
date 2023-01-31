// SVG サイズ設定
var width = 800, height = 800;

// SVG 要素追加
var svg = d3.select("#map").append("svg")
    .attr("width", width)
    .attr("height", height);

// JSON データ読み込み
d3.json("japan.topojson", function (json) {
    var japan = topojson.object(json, json.objects.japan).geometries;

    // 投影法設定
    var projection = d3.geo.mercator()
        .center([138, 34])
        .scale(1200)
        .translate([width / 2, height / 2]);

    // 緯度・経度 => パス変換
    var path = d3.geo.path()
        .projection(projection);

    // 地図描画
    svg.selectAll("path")
})