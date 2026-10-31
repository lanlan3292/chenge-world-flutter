import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../l10n/generated/app_localizations.dart';
import 'chat_chart.dart';

/// 聊天气泡内的 Markdown 渲染，并把 ```chart / ```diagram / ```table
/// 围栏替换成可视化组件（其余围栏仍按代码块显示）。
class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown({
    super.key,
    required this.source,
    required this.textColor,
    this.linkColor,
    this.fontSize = 15,
  });

  final String source;
  final Color textColor;
  final Color? linkColor;
  final double fontSize;

  static final RegExp _fencePattern = RegExp(
    r'```([A-Za-z0-9_+-]*)[ \t]*\r?\n([\s\S]*?)```',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = <Widget>[];
    var cursor = 0;

    for (final match in _fencePattern.allMatches(source)) {
      if (match.start > cursor) {
        final text = source.substring(cursor, match.start);
        if (text.trim().isNotEmpty) {
          blocks.add(_markdown(context, theme, text));
        }
      }
      final lang = (match.group(1) ?? '').toLowerCase().trim();
      final body = match.group(2) ?? '';
      final visual = _visualFence(lang, body);
      if (visual != null) {
        blocks.add(visual);
      } else {
        blocks.add(_markdown(context, theme, '```$lang\n$body```'));
      }
      cursor = match.end;
    }
    if (cursor < source.length) {
      final tail = source.substring(cursor);
      if (tail.trim().isNotEmpty) blocks.add(_markdown(context, theme, tail));
    }
    if (blocks.isEmpty) blocks.add(_markdown(context, theme, source));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          blocks[i],
        ],
      ],
    );
  }

  Widget? _visualFence(String lang, String body) {
    switch (lang) {
      case 'chart':
        return ChatChart.fromSource(body, textColor: textColor);
      case 'diagram':
        return ChatDiagram.fromSource(body, textColor: textColor);
      case 'table':
        return ChatFenceTable.fromSource(body, textColor: textColor);
      default:
        return null;
    }
  }

  Widget _markdown(BuildContext context, ThemeData theme, String data) {
    final codeBackground = textColor.withValues(alpha: 0.08);
    final resolvedLink = linkColor ?? theme.colorScheme.primary;
    final style = MarkdownStyleSheet(
      p: TextStyle(color: textColor, height: 1.45, fontSize: fontSize),
      a: TextStyle(
        color: resolvedLink,
        decoration: TextDecoration.underline,
        decorationColor: resolvedLink,
      ),
      strong: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      em: TextStyle(color: textColor, fontStyle: FontStyle.italic),
      code: TextStyle(
        color: textColor,
        fontSize: fontSize - 1.5,
        backgroundColor: codeBackground,
      ),
      codeblockPadding: const EdgeInsets.all(10),
      codeblockDecoration: BoxDecoration(
        color: codeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      blockquote: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: fontSize),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: textColor.withValues(alpha: 0.3), width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
      listBullet: TextStyle(color: textColor, fontSize: fontSize),
      listIndent: 18,
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: textColor.withValues(alpha: 0.2))),
      ),
      h1: TextStyle(color: textColor, fontSize: fontSize + 5, fontWeight: FontWeight.w800),
      h2: TextStyle(color: textColor, fontSize: fontSize + 3, fontWeight: FontWeight.w800),
      h3: TextStyle(color: textColor, fontSize: fontSize + 1, fontWeight: FontWeight.w700),
      h4: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w700),
      h5: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600),
      h6: TextStyle(color: textColor, fontSize: fontSize - 1, fontWeight: FontWeight.w600),
      tableHead: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: fontSize - 2),
      tableBody: TextStyle(color: textColor, fontSize: fontSize - 2),
      tableBorder: TableBorder.all(color: textColor.withValues(alpha: 0.2)),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      tableColumnWidth: const IntrinsicColumnWidth(),
    );

    return MarkdownBody(
      data: data,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubWeb,
      styleSheet: style,
      onTapLink: (text, href, title) => _onTapLink(context, href),
    );
  }

  void _onTapLink(BuildContext context, String? href) {
    if (href == null || href.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    unawaited(Clipboard.setData(ClipboardData(text: href)));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).chatCopied)),
      );
  }
}
