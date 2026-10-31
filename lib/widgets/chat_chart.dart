import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// 聊天气泡里渲染 AI 数据围栏的图表：```chart / ```diagram / ```table。
///
/// 协议与 Web 端 `VisualFence.vue` 对齐（fence_registry.json）：
/// chart: {version, title, type: bar|line|area|pie|scatter, x, series:[{name,data}],
///         unit, stacked, horizontal}
/// diagram: {version, direction, nodes:[{id,label,kind,description}],
///           edges:[{from,to,label}]}
/// table: {version, columns:[{key,label}], rows:[{...}]}
class ChatChart extends StatelessWidget {
  const ChatChart._(this.spec, {required this.textColor});

  final ChatChartSpec spec;
  final Color textColor;

  static Widget fromSource(String source, {required Color textColor}) {
    final spec = ChatChartSpec.parse(source);
    if (spec == null) return _FenceFallback(textColor: textColor);
    return ChatChart._(spec, textColor: textColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surfaceContainerLowest;
    final border = theme.colorScheme.outlineVariant;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((spec.title ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                spec.title!,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: CustomPaint(painter: _ChartPainter(spec, textColor)),
          ),
          if (spec.legend.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Wrap(
                spacing: 10,
                runSpacing: 4,
                children: [
                  for (var i = 0; i < spec.legend.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _palette[i % _palette.length],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          spec.legend[i],
                          style: TextStyle(fontSize: 11, color: textColor),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

const _palette = <Color>[
  Color(0xFF4C8C6F),
  Color(0xFFE0A458),
  Color(0xFF5B8DEF),
  Color(0xFFD96A6A),
  Color(0xFF8E7CC3),
  Color(0xFF56B4A6),
  Color(0xFFB57BA6),
  Color(0xFF7A8B99),
];

class ChatChartSpec {
  ChatChartSpec({
    required this.type,
    required this.title,
    required this.x,
    required this.series,
    required this.stacked,
    required this.horizontal,
    required this.unit,
  });

  final String type;
  final String? title;
  final List<String> x;
  final List<ChatChartSeries> series;
  final bool stacked;
  final bool horizontal;
  final String? unit;

  List<String> get legend =>
      series.where((item) => item.name.isNotEmpty).map((item) => item.name).toList();

  static ChatChartSpec? parse(String source) {
    try {
      final raw = jsonDecode(source.trim());
      if (raw is! Map) return null;
      final map = raw.cast<String, dynamic>();
      final type = (map['type'] ?? '').toString().toLowerCase();
      if (!const ['bar', 'line', 'area', 'pie', 'scatter'].contains(type)) {
        return null;
      }
      final x = <String>[];
      final rawX = map['x'] ?? map['labels'] ?? map['categories'];
      if (rawX is List) {
        for (final item in rawX) {
          x.add(item?.toString() ?? '');
        }
      }
      final series = <ChatChartSeries>[];
      final rawSeries = map['series'];
      if (rawSeries is List) {
        for (final item in rawSeries) {
          if (item is! Map) continue;
          final entry = item.cast<String, dynamic>();
          final name = (entry['name'] ?? '').toString();
          final data = <List<double>>[];
          final rawData = entry['data'];
          if (rawData is List) {
            for (final point in rawData) {
              if (point is List && point.length >= 2) {
                final xv = _number(point[0]);
                final yv = _number(point[1]);
                if (xv != null && yv != null) data.add([xv, yv]);
              } else {
                final value = _number(point);
                data.add([double.nan, value ?? double.nan]);
              }
            }
          }
          series.add(ChatChartSeries(name, data));
        }
      }
      if (series.isEmpty) return null;
      final maxSeries = series.length > 12 ? series.sublist(0, 12) : series;
      return ChatChartSpec(
        type: type,
        title: _text(map['title']),
        x: x.length > 1000 ? x.sublist(0, 1000) : x,
        series: maxSeries,
        stacked: map['stacked'] == true,
        horizontal: map['horizontal'] == true,
        unit: _text(map['unit']),
      );
    } catch (_) {
      return null;
    }
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }

  static double? _number(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class ChatChartSeries {
  ChatChartSeries(this.name, this.points);

  final String name;
  final List<List<double>> points;
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.spec, this.textColor);

  final ChatChartSpec spec;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (spec.type == 'pie') {
      _paintPie(canvas, size);
      return;
    }
    const left = 38.0;
    const bottom = 22.0;
    const top = 8.0;
    const right = 8.0;
    final plot = Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    if (plot.width <= 8 || plot.height <= 8) return;

    if (spec.type == 'scatter') {
      _paintScatter(canvas, plot);
      return;
    }

    final values = <double>[];
    for (final item in spec.series) {
      for (final point in item.points) {
        if (!point[1].isNaN) values.add(point[1]);
      }
    }
    if (values.isEmpty) return;
    final rawMax = values.reduce(math.max);
    final rawMin = values.reduce(math.min);
    var maxValue = rawMax;
    var minValue = spec.type == 'bar' || spec.type == 'area' ? math.min(0.0, rawMin) : rawMin;
    if (maxValue == minValue) {
      maxValue = maxValue + 1;
      minValue = minValue - 1;
    }
    if (spec.stacked) {
      final totals = <double>[];
      final count = spec.x.isNotEmpty
          ? spec.x.length
          : spec.series
              .map((item) => item.points.length)
              .reduce((a, b) => math.max(a, b));
      for (var i = 0; i < count; i++) {
        var total = 0.0;
        for (final item in spec.series) {
          final value = i < item.points.length ? item.points[i][1] : double.nan;
          if (!value.isNaN) total += value;
        }
        totals.add(total);
      }
      if (totals.isNotEmpty) {
        maxValue = math.max(maxValue, totals.reduce(math.max));
      }
    }
    final range = maxValue - minValue;

    double yOf(double value) => plot.bottom - (value - minValue) / range * plot.height;

    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final value = minValue + range * i / 4;
      final y = yOf(value);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      _drawText(
        canvas,
        _formatValue(value),
        Offset(plot.left - 6, y),
        alignRight: true,
        alignMiddle: true,
        size: 9.5,
      );
    }

    final categoryCount = math.max(
      spec.x.length,
      spec.series.map((item) => item.points.length).fold<int>(0, math.max),
    );
    final step = categoryCount <= 1 ? plot.width : plot.width / (categoryCount - 1);

    if (spec.type == 'bar' || spec.type == 'area') {
      final groupWidth = categoryCount == 0 ? plot.width : plot.width / categoryCount;
      if (spec.type == 'bar' && !spec.horizontal) {
        final bars = spec.stacked ? 1 : spec.series.length;
        final barWidth = (groupWidth * 0.62 / bars).clamp(1.0, 48.0);
        for (var c = 0; c < categoryCount; c++) {
          final groupLeft = plot.left + groupWidth * c + (groupWidth - barWidth * bars) / 2;
          var stackBase = 0.0;
          for (var s = 0; s < spec.series.length; s++) {
            final item = spec.series[s];
            final value = c < item.points.length ? item.points[c][1] : double.nan;
            if (value.isNaN) continue;
            final paint = Paint()..color = _palette[s % _palette.length];
            final startValue = spec.stacked ? stackBase : math.min(0.0, value);
            final endValue = spec.stacked ? stackBase + value : math.max(0.0, value);
            final rect = Rect.fromLTRB(
              groupLeft + barWidth * (spec.stacked ? 0 : s),
              yOf(endValue),
              groupLeft + barWidth * (spec.stacked ? 1 : s + 1) - 1,
              yOf(startValue),
            );
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, const Radius.circular(2)),
              paint,
            );
            if (spec.stacked) stackBase += value;
          }
        }
      } else if (spec.type == 'bar' && spec.horizontal) {
        final barHeight = (groupWidth * 0.62).clamp(1.0, 40.0);
        for (var c = 0; c < categoryCount; c++) {
          final centerY = plot.top + groupWidth * c + groupWidth / 2;
          for (var s = 0; s < spec.series.length; s++) {
            final item = spec.series[s];
            final value = c < item.points.length ? item.points[c][1] : double.nan;
            if (value.isNaN) continue;
            final width = (value - minValue) / range * plot.width;
            final paint = Paint()..color = _palette[s % _palette.length];
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  plot.left,
                  centerY - barHeight / 2 + s * barHeight / spec.series.length,
                  width.abs(),
                  barHeight / spec.series.length - 1,
                ),
                const Radius.circular(2),
              ),
              paint,
            );
          }
        }
      } else {
        _paintStackedArea(canvas, plot, yOf, step);
      }
      _drawCategoryLabels(canvas, plot, categoryCount, groupWidth);
    } else {
      // line / area（非堆叠）
      for (var s = 0; s < spec.series.length; s++) {
        final item = spec.series[s];
        final path = Path();
        var started = false;
        final points = <Offset>[];
        for (var i = 0; i < item.points.length; i++) {
          final value = item.points[i][1];
          if (value.isNaN) {
            started = false;
            continue;
          }
          final offset = Offset(plot.left + step * i, yOf(value));
          points.add(offset);
          if (!started) {
            path.moveTo(offset.dx, offset.dy);
            started = true;
          } else {
            path.lineTo(offset.dx, offset.dy);
          }
        }
        if (spec.type == 'area' && points.isNotEmpty) {
          final fill = Path.from(path)
            ..lineTo(points.last.dx, plot.bottom)
            ..lineTo(points.first.dx, plot.bottom)
            ..close();
          canvas.drawPath(
            fill,
            Paint()..color = _palette[s % _palette.length].withValues(alpha: 0.18),
          );
        }
        canvas.drawPath(
          path,
          Paint()
            ..color = _palette[s % _palette.length]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
        for (final point in points) {
          canvas.drawCircle(
            point,
            2.4,
            Paint()..color = _palette[s % _palette.length],
          );
        }
      }
      _drawCategoryLabels(canvas, plot, categoryCount, step == 0 ? 1 : step);
    }

    if ((spec.unit ?? '').isNotEmpty) {
      _drawText(
        canvas,
        spec.unit!,
        Offset(plot.left, plot.top - 2),
        size: 9,
      );
    }
  }

  void _paintStackedArea(
    Canvas canvas,
    Rect plot,
    double Function(double) yOf,
    double step,
  ) {
    final count = spec.x.isNotEmpty
        ? spec.x.length
        : spec.series.map((item) => item.points.length).fold<int>(0, math.max);
    if (count == 0) return;
    final cumulative = List<double>.filled(count, 0);
    for (var s = 0; s < spec.series.length; s++) {
      final item = spec.series[s];
      final top = <Offset>[];
      final bottom = <Offset>[];
      for (var i = 0; i < count; i++) {
        final value = i < item.points.length ? item.points[i][1] : double.nan;
        final base = cumulative[i];
        if (!value.isNaN) cumulative[i] = base + value;
        final x = plot.left + step * i;
        top.add(Offset(x, yOf(cumulative[i])));
        bottom.add(Offset(x, yOf(base)));
      }
      final path = Path()..moveTo(top.first.dx, top.first.dy);
      for (final point in top.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      for (final point in bottom.reversed) {
        path.lineTo(point.dx, point.dy);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()..color = _palette[s % _palette.length].withValues(alpha: 0.35),
      );
      canvas.drawPath(
        Path()..addPolygon(top, false),
        Paint()
          ..color = _palette[s % _palette.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawCategoryLabels(
    Canvas canvas,
    Rect plot,
    int count,
    double step,
  ) {
    if (spec.x.isEmpty || count == 0) return;
    final maxLabels = math.max(2, (plot.width / 46).floor());
    final stride = math.max(1, (count / maxLabels).ceil());
    for (var i = 0; i < spec.x.length && i < count; i += stride) {
      final x = spec.x.length == count
          ? plot.left + step * i + (spec.type == 'bar' ? step / 2 : 0)
          : plot.left + step * i;
      final label = spec.x[i];
      if (label.isEmpty) continue;
      _drawText(
        canvas,
        label.length > 8 ? '${label.substring(0, 8)}…' : label,
        Offset(x, plot.bottom + 4),
        alignMiddle: true,
        size: 9.5,
      );
    }
  }

  void _paintPie(Canvas canvas, Size size) {
    final first = spec.series.first;
    final values = <double>[];
    for (final point in first.points) {
      if (!point[1].isNaN) values.add(point[1].abs());
    }
    final total = values.fold<double>(0, (sum, value) => sum + value);
    if (total <= 0) return;
    final radius = math.min(size.width, size.height) * 0.42;
    final center = Offset(size.width / 2, size.height / 2);
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        Paint()..color = _palette[i % _palette.length],
      );
      start += sweep;
    }
    canvas.drawCircle(
      center,
      radius * 0.52,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );
    _drawText(
      canvas,
      _formatValue(total),
      Offset(center.dx, center.dy),
      alignMiddle: true,
      alignVerticalCenter: true,
      size: 11,
      bold: true,
    );
  }

  void _paintScatter(Canvas canvas, Rect plot) {
    final points = <Offset>[];
    final xs = <double>[];
    final ys = <double>[];
    for (var s = 0; s < spec.series.length; s++) {
      final item = spec.series[s];
      for (final point in item.points) {
        if (point[0].isNaN || point[1].isNaN) continue;
        xs.add(point[0]);
        ys.add(point[1]);
      }
    }
    if (xs.isEmpty) return;
    final minX = xs.reduce(math.min);
    final maxX = xs.reduce(math.max);
    final minY = ys.reduce(math.min);
    final maxY = ys.reduce(math.max);
    final rangeX = maxX - minX == 0 ? 1.0 : maxX - minX;
    final rangeY = maxY - minY == 0 ? 1.0 : maxY - minY;

    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = plot.bottom - plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      _drawText(
        canvas,
        _formatValue(minY + rangeY * i / 4),
        Offset(plot.left - 6, y),
        alignRight: true,
        alignMiddle: true,
        size: 9.5,
      );
    }
    for (var s = 0; s < spec.series.length; s++) {
      final paint = Paint()..color = _palette[s % _palette.length];
      for (final point in spec.series[s].points) {
        if (point[0].isNaN || point[1].isNaN) continue;
        final dx = plot.left + (point[0] - minX) / rangeX * plot.width;
        final dy = plot.bottom - (point[1] - minY) / rangeY * plot.height;
        points.add(Offset(dx, dy));
        canvas.drawCircle(Offset(dx, dy), 3, paint);
      }
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    bool alignRight = false,
    bool alignMiddle = false,
    bool alignVerticalCenter = false,
    double size = 10,
    bool bold = false,
  }) {
    if (text.isEmpty) return;
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.68),
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    var dx = offset.dx;
    if (alignRight) dx -= painter.width;
    if (alignMiddle) dx -= painter.width / 2;
    var dy = offset.dy;
    if (alignMiddle) dy -= painter.height / 2;
    if (alignVerticalCenter) dy -= painter.height / 2;
    painter.paint(canvas, Offset(dx, dy));
  }

  String _formatValue(double value) {
    final abs = value.abs();
    if (abs >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    if (abs >= 10 || abs == abs.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) => false;
}

/// 流程图围栏：用节点列表 + 连线文本呈现，避免引入图形引擎。
class ChatDiagram extends StatelessWidget {
  const ChatDiagram._({
    required this.nodes,
    required this.edges,
    required this.direction,
    required this.textColor,
  });

  final List<ChatDiagramNode> nodes;
  final List<ChatDiagramEdge> edges;
  final String direction;
  final Color textColor;

  static Widget fromSource(String source, {required Color textColor}) {
    try {
      final raw = jsonDecode(source.trim());
      if (raw is! Map) return _FenceFallback(textColor: textColor);
      final map = raw.cast<String, dynamic>();
      final nodes = <ChatDiagramNode>[];
      final rawNodes = map['nodes'];
      if (rawNodes is List) {
        for (final item in rawNodes.take(100)) {
          if (item is! Map) continue;
          final node = item.cast<String, dynamic>();
          final label = (node['label'] ?? node['id'] ?? '').toString().trim();
          if (label.isEmpty) continue;
          nodes.add(
            ChatDiagramNode(
              id: (node['id'] ?? label).toString(),
              label: label,
              kind: (node['kind'] ?? 'process').toString(),
              description: (node['description'] ?? '').toString(),
            ),
          );
        }
      }
      final edges = <ChatDiagramEdge>[];
      final rawEdges = map['edges'];
      if (rawEdges is List) {
        for (final item in rawEdges.take(250)) {
          if (item is! Map) continue;
          final edge = item.cast<String, dynamic>();
          final from = (edge['from'] ?? '').toString();
          final to = (edge['to'] ?? '').toString();
          if (from.isEmpty || to.isEmpty) continue;
          edges.add(ChatDiagramEdge(from, to, (edge['label'] ?? '').toString()));
        }
      }
      if (nodes.isEmpty) return _FenceFallback(textColor: textColor);
      return ChatDiagram._(
        nodes: nodes,
        edges: edges,
        direction: (map['direction'] ?? 'TB').toString(),
        textColor: textColor,
      );
    } catch (_) {
      return _FenceFallback(textColor: textColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final node in nodes)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_kindIcon(node.kind), size: 13, color: _kindColor(node.kind)),
                      const SizedBox(width: 4),
                      Text(
                        node.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (edges.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final edge in edges)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Text(
                      _labelOf(edge.from),
                      style: TextStyle(fontSize: 11.5, color: textColor.withValues(alpha: 0.85)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        direction == 'LR' ? Icons.arrow_forward : Icons.arrow_downward,
                        size: 12,
                        color: textColor.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      _labelOf(edge.to),
                      style: TextStyle(fontSize: 11.5, color: textColor.withValues(alpha: 0.85)),
                    ),
                    if (edge.label.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '（${edge.label}）',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _labelOf(String id) {
    for (final node in nodes) {
      if (node.id == id) return node.label;
    }
    return id;
  }

  static IconData _kindIcon(String kind) => switch (kind) {
    'decision' => Icons.call_split_rounded,
    'start' => Icons.play_arrow_rounded,
    'end' => Icons.stop_rounded,
    'data' => Icons.storage_rounded,
    _ => Icons.circle_outlined,
  };

  static Color _kindColor(String kind) => switch (kind) {
    'decision' => const Color(0xFFE0A458),
    'start' => const Color(0xFF4C8C6F),
    'end' => const Color(0xFFD96A6A),
    'data' => const Color(0xFF5B8DEF),
    _ => const Color(0xFF7A8B99),
  };
}

class ChatDiagramNode {
  ChatDiagramNode({
    required this.id,
    required this.label,
    required this.kind,
    required this.description,
  });

  final String id;
  final String label;
  final String kind;
  final String description;
}

class ChatDiagramEdge {
  ChatDiagramEdge(this.from, this.to, this.label);

  final String from;
  final String to;
  final String label;
}

/// 表格围栏：{columns:[{key,label}], rows:[{...}]}。
class ChatFenceTable extends StatelessWidget {
  const ChatFenceTable._({
    required this.columns,
    required this.rows,
    required this.textColor,
  });

  final List<ChatTableColumn> columns;
  final List<List<String>> rows;
  final Color textColor;

  static Widget fromSource(String source, {required Color textColor}) {
    try {
      final raw = jsonDecode(source.trim());
      if (raw is! Map) return _FenceFallback(textColor: textColor);
      final map = raw.cast<String, dynamic>();
      final columns = <ChatTableColumn>[];
      final rawColumns = map['columns'];
      if (rawColumns is List) {
        for (final item in rawColumns.take(12)) {
          if (item is Map) {
            final column = item.cast<String, dynamic>();
            columns.add(
              ChatTableColumn(
                (column['key'] ?? column['label'] ?? '').toString(),
                (column['label'] ?? column['key'] ?? '').toString(),
              ),
            );
          } else if (item != null) {
            columns.add(ChatTableColumn('$item', '$item'));
          }
        }
      }
      final rows = <List<String>>[];
      final rawRows = map['rows'];
      if (rawRows is List) {
        for (final item in rawRows.take(200)) {
          if (item is Map) {
            final row = item.cast<String, dynamic>();
            rows.add([
              for (final column in columns) _cell(row[column.key]),
            ]);
          } else if (item is List) {
            rows.add([for (final cell in item) _cell(cell)]);
          }
        }
      }
      if (columns.isEmpty && rows.isEmpty) return _FenceFallback(textColor: textColor);
      return ChatFenceTable._(columns: columns, rows: rows, textColor: textColor);
    } catch (_) {
      return _FenceFallback(textColor: textColor);
    }
  }

  static String _cell(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.length > 60 ? '${text.substring(0, 60)}…' : text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: theme.colorScheme.outlineVariant),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            if (columns.isNotEmpty)
              TableRow(
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHigh),
                children: [
                  for (final column in columns)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        column.label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in rows)
              TableRow(
                children: [
                  for (var i = 0; i < math.max(columns.length, row.length); i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text(
                        i < row.length ? row[i] : '',
                        style: TextStyle(fontSize: 11.5, color: textColor),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ChatTableColumn {
  ChatTableColumn(this.key, this.label);

  final String key;
  final String label;
}

class _FenceFallback extends StatelessWidget {
  const _FenceFallback({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppLocalizations.of(context).chatChartUnavailable,
        style: TextStyle(fontSize: 11.5, color: textColor.withValues(alpha: 0.6)),
      ),
    );
  }
}
