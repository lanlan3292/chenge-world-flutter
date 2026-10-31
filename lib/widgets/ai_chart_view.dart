import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ai_chart.dart';

/// 图表卡片：标题 + 画布 + 图例 + 数据表 / 源码切换。
class AiChartCard extends StatefulWidget {
  const AiChartCard({super.key, required this.source});

  final String source;

  @override
  State<AiChartCard> createState() => _AiChartCardState();
}

class _AiChartCardState extends State<AiChartCard> {
  bool _showTable = false;
  bool _showSource = false;

  @override
  Widget build(BuildContext context) {
    AiChartData? chart;
    String? error;
    try {
      chart = AiChartData.parse(widget.source);
    } on FormatException catch (formatError) {
      error = formatError.message;
    }
    if (error != null) {
      return _shell(
        header: const Text('数据图表', style: TextStyle(fontWeight: FontWeight.w800)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '无法渲染：$error。可展开源码检查。',
              style: const TextStyle(color: Color(0xFFB3261E), fontSize: 12.5),
            ),
            if (_showSource)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                color: const Color(0xFFF2F0E6),
                child: SelectableText(
                  widget.source,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _showSource = !_showSource),
                child: Text(_showSource ? '收起源码' : '源码'),
              ),
            ),
          ],
        ),
      );
    }

    final data = chart!;
    return _shell(
      header: Row(
        children: [
          Expanded(
            child: Text(
              data.title.isEmpty ? '数据图表' : data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _showTable = !_showTable),
            child: Text(_showTable ? '收起数据' : '查看数据'),
          ),
          TextButton(
            onPressed: () => setState(() => _showSource = !_showSource),
            child: Text(_showSource ? '收起源码' : '源码'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                data.description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF5B6B66)),
              ),
            ),
          if (data.warning.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                data.warning,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF8A6D1F)),
              ),
            ),
          SizedBox(
            height: 320,
            child: CustomPaint(
              painter: _AiChartPainter(
                data: data,
                textColor: const Color(0xFF354D39),
                palette: _AiChartPalette.colors,
                background: const Color(0xFFFAF8EF),
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              for (var i = 0; i < data.series.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: _AiChartPalette.colors[i % _AiChartPalette.colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(data.series[i].name, style: const TextStyle(fontSize: 11)),
                  ],
                ),
            ],
          ),
          if (_showTable) ...[
            const SizedBox(height: 8),
            _dataTable(data),
          ],
          if (_showSource) ...[
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF2F0E6),
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    widget.source,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dataTable(AiChartData data) {
    final header = <String>[
      data.xLabel.isEmpty ? '分类 / X' : data.xLabel,
      for (final series in data.series)
        series.name + (data.unit.isEmpty ? '' : ' / ${data.unit}'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 32,
        dataRowMinHeight: 26,
        dataRowMaxHeight: 30,
        columns: [
          for (final cell in header)
            DataColumn(
              label: Text(cell, style: const TextStyle(fontSize: 11)),
            ),
        ],
        rows: [
          for (var row = 0; row < data.x.length; row++)
            DataRow(
              cells: [
                DataCell(Text(data.x[row], style: const TextStyle(fontSize: 11))),
                for (final series in data.series)
                  DataCell(
                    Text(
                      row < series.data.length
                          ? (series.data[row]?.toString() ?? '—')
                          : '—',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _shell({required Widget header, required Widget body}) => Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFAF8EF),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE2E0D2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(style: const TextStyle(fontSize: 12), child: header),
        body,
      ],
    ),
  );
}

class _AiChartPalette {
  static const colors = [
    Color(0xFF4F7957),
    Color(0xFF688BA3),
    Color(0xFFB18B48),
    Color(0xFFA86F72),
    Color(0xFF7B75A2),
    Color(0xFF59968B),
    Color(0xFF8B9C45),
    Color(0xFFB47C50),
  ];
}

class _AiChartPainter extends CustomPainter {
  _AiChartPainter({
    required this.data,
    required this.textColor,
    required this.palette,
    required this.background,
  });

  final AiChartData data;
  final Color textColor;
  final List<Color> palette;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    if (data.type == 'pie') {
      _paintPie(canvas, size);
      return;
    }
    const padding = EdgeInsets.fromLTRB(44, 12, 12, 34);
    final plot = Rect.fromLTRB(
      padding.left,
      padding.top,
      size.width - padding.right,
      size.height - padding.bottom,
    );
    var min = 0.0;
    var max = 0.0;
    for (final series in data.series) {
      for (final value in series.data) {
        if (value == null) continue;
        final number = value.toDouble();
        if (number < min) min = number;
        if (number > max) max = number;
      }
    }
    if (max == min) max = min + 1;

    _paintGrid(canvas, plot, min, max);

    switch (data.type) {
      case 'bar':
        _paintBars(canvas, plot, min, max);
        break;
      case 'line':
      case 'area':
        _paintLines(canvas, plot, min, max, fill: data.type == 'area');
        break;
      case 'scatter':
        _paintScatter(canvas, plot, min, max);
        break;
    }

    _paintXLabels(canvas, plot);
  }

  void _paintGrid(Canvas canvas, Rect plot, double min, double max) {
    final paint = Paint()
      ..color = const Color(0xFFD9D7C7)
      ..strokeWidth = 1;
    const steps = 4;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i <= steps; i++) {
      final y = plot.bottom - plot.height * i / steps;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), paint);
      final value = min + (max - min) * i / steps;
      textPainter
        ..text = TextSpan(
          text: _formatNumber(value),
          style: TextStyle(fontSize: 9, color: textColor.withValues(alpha: 0.7)),
        )
        ..layout();
      textPainter.paint(
        canvas,
        Offset(plot.left - textPainter.width - 4, y - textPainter.height / 2),
      );
    }
  }

  void _paintBars(Canvas canvas, Rect plot, double min, double max) {
    final count = data.x.length;
    if (count == 0) return;
    final groupWidth = plot.width / count;
    final seriesCount = data.series.length;
    final barWidth = math.max(2.0, (groupWidth * 0.8) / seriesCount);
    for (var i = 0; i < count; i++) {
      for (var s = 0; s < seriesCount; s++) {
        final value = i < data.series[s].data.length ? data.series[s].data[i] : null;
        if (value == null) continue;
        final normalized = (value.toDouble() - min) / (max - min);
        final height = plot.height * normalized;
        final left =
            plot.left +
            groupWidth * i +
            (groupWidth - barWidth * seriesCount) / 2 +
            barWidth * s;
        final rect = Rect.fromLTWH(left, plot.bottom - height, barWidth * 0.9, height);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = palette[s % palette.length],
        );
      }
    }
  }

  void _paintLines(Canvas canvas, Rect plot, double min, double max, {required bool fill}) {
    final count = data.x.length;
    if (count == 0) return;
    final stepX = count == 1 ? 0.0 : plot.width / (count - 1);
    for (var s = 0; s < data.series.length; s++) {
      final color = palette[s % palette.length];
      final path = Path();
      final areaPath = Path();
      var started = false;
      var lastX = 0.0;
      for (var i = 0; i < count; i++) {
        final value = i < data.series[s].data.length ? data.series[s].data[i] : null;
        if (value == null) continue;
        final normalized = (value.toDouble() - min) / (max - min);
        final x = plot.left + stepX * i;
        final y = plot.bottom - plot.height * normalized;
        if (!started) {
          path.moveTo(x, y);
          areaPath
            ..moveTo(x, plot.bottom)
            ..lineTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
          areaPath.lineTo(x, y);
        }
        lastX = x;
      }
      if (!started) continue;
      if (fill) {
        areaPath
          ..lineTo(lastX, plot.bottom)
          ..close();
        canvas.drawPath(areaPath, Paint()..color = color.withValues(alpha: 0.18));
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      for (var i = 0; i < count; i++) {
        final value = i < data.series[s].data.length ? data.series[s].data[i] : null;
        if (value == null) continue;
        final normalized = (value.toDouble() - min) / (max - min);
        canvas.drawCircle(
          Offset(plot.left + stepX * i, plot.bottom - plot.height * normalized),
          2.2,
          Paint()..color = color,
        );
      }
    }
  }

  void _paintScatter(Canvas canvas, Rect plot, double min, double max) {
    for (var s = 0; s < data.series.length; s++) {
      final color = palette[s % palette.length];
      final count = data.series[s].data.length;
      for (var i = 0; i < count; i++) {
        final value = data.series[s].data[i];
        if (value == null) continue;
        final normalizedY = (value.toDouble() - min) / (max - min);
        final x = plot.left + (count == 1 ? plot.width / 2 : plot.width * i / (count - 1));
        canvas.drawCircle(
          Offset(x, plot.bottom - plot.height * normalizedY),
          3,
          Paint()..color = color,
        );
      }
    }
  }

  void _paintXLabels(Canvas canvas, Rect plot) {
    final count = data.x.length;
    if (count == 0) return;
    final stepX = count == 1 ? 0.0 : plot.width / (count - 1);
    final step = count > 12 ? (count / 8).ceil() : 1;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    );
    for (var i = 0; i < count; i += step) {
      final x = count == 1 ? plot.center.dx : plot.left + stepX * i;
      textPainter
        ..text = TextSpan(
          text: data.x[i],
          style: TextStyle(fontSize: 9, color: textColor.withValues(alpha: 0.8)),
        )
        ..layout(maxWidth: 60);
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, plot.bottom + 4));
    }
  }

  void _paintPie(Canvas canvas, Size size) {
    final series = data.series.first;
    final total = series.data.fold<double>(
      0,
      (sum, value) => sum + (value?.toDouble() ?? 0),
    );
    final radius = math.min(size.width, size.height) * 0.3;
    final center = Offset(size.width / 2, size.height / 2);
    var start = -math.pi / 2;
    for (var i = 0; i < series.data.length; i++) {
      final value = series.data[i]?.toDouble() ?? 0;
      if (value <= 0) continue;
      final sweep = math.pi * 2 * (value / total);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        Paint()..color = palette[i % palette.length],
      );
      start += sweep;
    }
    final textPainter = TextPainter(textDirection: TextDirection.ltr, maxLines: 1);
    var y = 8.0;
    for (var i = 0; i < data.x.length && i < 12; i++) {
      final color = palette[i % palette.length];
      canvas.drawRect(Rect.fromLTWH(8, y + 2, 8, 8), Paint()..color = color);
      textPainter
        ..text = TextSpan(
          text: data.x[i],
          style: TextStyle(fontSize: 10, color: textColor),
        )
        ..layout(maxWidth: 130);
      textPainter.paint(canvas, Offset(20, y));
      y += 15;
    }
  }

  String _formatNumber(double value) {
    if (value.abs() >= 10000) return '${(value / 1000).toStringAsFixed(0)}k';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _AiChartPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.data.series != data.series;
}
