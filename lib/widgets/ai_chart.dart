import 'dart:convert';
import 'dart:math' as math;


/// AI 输出的 ```chart fenced JSON（协议与 web 的 visualFence 保持一致）。
class AiChartSeries {
  const AiChartSeries({required this.name, required this.data});

  final String name;
  final List<num?> data;
}

class AiChartData {
  const AiChartData({
    required this.type,
    required this.x,
    required this.series,
    this.title = '',
    this.description = '',
    this.unit = '',
    this.xLabel = '',
    this.yLabel = '',
    this.stacked = false,
    this.horizontal = false,
    this.warning = '',
  });

  final String type;
  final List<String> x;
  final List<AiChartSeries> series;
  final String title;
  final String description;
  final String unit;
  final String xLabel;
  final String yLabel;
  final bool stacked;
  final bool horizontal;
  final String warning;

  static const types = {'bar', 'line', 'area', 'pie', 'scatter'};

  factory AiChartData.parse(String source) {
    if (source.length > 500 * 1024) {
      throw const FormatException('内容超过 500KB，请拆分展示');
    }
    dynamic decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const FormatException('JSON 格式无效，请检查引号、逗号及括号');
    }
    if (decoded is! Map) throw const FormatException('内容必须为 JSON 对象');
    final version = decoded['version'];
    if (version is! num || version.toInt() != 1) {
      throw const FormatException('version 必须为 1');
    }
    final type = (decoded['type'] ?? '').toString();
    if (!types.contains(type)) {
      throw const FormatException('图表类型支持 bar / line / area / pie / scatter');
    }
    final rawSeries = decoded['series'];
    if (rawSeries is! List || rawSeries.isEmpty) {
      throw const FormatException('至少提供一个数据系列');
    }
    if (rawSeries.length > 12) {
      throw const FormatException('series 必须为数组，最多 12 项');
    }
    final rawX = decoded['x'];
    final x = <String>[
      if (rawX is List)
        for (final item in rawX) _cut(item?.toString() ?? '', 120),
    ];
    final series = <AiChartSeries>[];
    for (var index = 0; index < rawSeries.length; index++) {
      final item = rawSeries[index];
      if (item is! Map) continue;
      final name = _cut((item['name'] ?? '系列 ${index + 1}').toString(), 2000);
      final rawData = item['data'];
      final data = <num?>[];
      if (rawData is List) {
        for (final value in rawData) {
          if (value == null) {
            data.add(null);
          } else if (value is num) {
            data.add(value);
          } else if (value is List) {
            // scatter: [x, y] —— 只保留 y，x 值由绘制端按顺序处理。
            if (value.length >= 2 && value[1] is num) {
              data.add(value[1] as num);
            } else {
              data.add(null);
            }
          } else {
            throw const FormatException('数据必须为有限数值；缺失值用 null；散点使用 [x,y]');
          }
        }
      }
      series.add(AiChartSeries(name: name, data: data));
    }
    if (series.isEmpty) throw const FormatException('至少提供一个数据系列');
    var warning = '';
    var chartX = x;
    if (type != 'scatter') {
      if (chartX.isEmpty) {
        if (type == 'pie') {
          final longest = series
              .map((item) => item.data.length)
              .fold<int>(0, math.max);
          chartX = [for (var i = 0; i < longest; i++) '未命名分类 ${i + 1}'];
          warning = 'AI 未提供分类标签，暂按数据顺序显示未命名分类；请让 AI 补充 x 标签以确认含义。';
        } else {
          throw const FormatException('请提供 x 分类标签');
        }
      }
      for (final item in series) {
        if (item.data.length != chartX.length) {
          throw const FormatException('系列数据长度必须与 x 一致');
        }
      }
    }
    if (type == 'pie') {
      if (series.length != 1) throw const FormatException('饼图需要一个系列且总量大于零');
      var total = 0.0;
      for (final value in series.first.data) {
        if (value == null || value < 0) {
          throw const FormatException('饼图数据必须为非负数');
        }
        total += value;
      }
      if (total <= 0) throw const FormatException('饼图需要一个系列且总量大于零');
    }
    return AiChartData(
      type: type,
      x: chartX,
      series: series,
      title: _cut((decoded['title'] ?? '').toString(), 2000),
      description: _cut((decoded['description'] ?? '').toString(), 2000),
      unit: _cut((decoded['unit'] ?? '').toString(), 2000),
      xLabel: _cut((decoded['xLabel'] ?? '').toString(), 2000),
      yLabel: _cut((decoded['yLabel'] ?? '').toString(), 2000),
      stacked: decoded['stacked'] == true,
      horizontal: decoded['horizontal'] == true,
      warning: warning,
    );
  }

  static String _cut(String value, int max) =>
      value.length > max ? value.substring(0, max) : value;
}
