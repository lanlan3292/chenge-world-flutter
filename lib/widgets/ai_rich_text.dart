import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'ai_chart_view.dart';
import 'ai_history_archive.dart';

/// 把 AI 消息里的 ```chart / ```history 围栏渲染成卡片，其余交给 Markdown。
class AiRichText extends StatelessWidget {
  const AiRichText({
    super.key,
    required this.content,
    this.styleSheet,
    this.selectable = true,
  });

  final String content;
  final MarkdownStyleSheet? styleSheet;
  final bool selectable;

  static final _fence = RegExp(r'```([A-Za-z0-9_+-]*)[ \t]*\r?\n([\s\S]*?)```');

  @override
  Widget build(BuildContext context) {
    final segments = <Widget>[];
    var cursor = 0;
    for (final match in _fence.allMatches(content)) {
      if (match.start > cursor) {
        final text = content.substring(cursor, match.start);
        if (text.trim().isNotEmpty) segments.add(_markdown(text));
      }
      final language = match.group(1)?.toLowerCase() ?? '';
      final body = match.group(2) ?? '';
      if (language == 'chart') {
        segments.add(AiChartCard(source: body));
      } else if (language == 'history') {
        segments.add(AiHistoryCard(source: body));
      } else {
        segments.add(_codeBlock(body, language));
      }
      cursor = match.end;
    }
    if (cursor < content.length) {
      final tail = content.substring(cursor);
      if (tail.trim().isNotEmpty) segments.add(_markdown(tail));
    }
    if (segments.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: segments,
    );
  }

  Widget _markdown(String data) => MarkdownBody(
    data: data,
    selectable: selectable,
    styleSheet: styleSheet,
  );

  Widget _codeBlock(String body, String language) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F0E6),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (language.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              language,
              style: const TextStyle(fontSize: 10, color: Color(0xFF7A6A4F)),
            ),
          ),
        SelectableText(
          body.trimRight(),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5, height: 1.5),
        ),
      ],
    ),
  );
}
