import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

import '../l10n/generated/app_localizations.dart';
import 'chat_chart.dart';

class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown({super.key, required this.source, required this.textColor, this.linkColor, this.fontSize = 15, this.onResourceTap, this.onResourcePreview});
  final String source;
  final Color textColor;
  final Color? linkColor;
  final double fontSize;
  final Future<void> Function(String kind, int id)? onResourceTap;
  final Future<Map<String, String>> Function(String kind, int id)? onResourcePreview;
  static final RegExp _fencePattern = RegExp(r'```([A-Za-z0-9_+-]*)[ \t]*\r?\n([\s\S]*?)```');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = <Widget>[];
    var cursor = 0;
    for (final match in _fencePattern.allMatches(source)) {
      if (match.start > cursor) {
        final text = source.substring(cursor, match.start);
        if (text.trim().isNotEmpty) blocks.add(_markdown(context, theme, text));
      }
      final lang = (match.group(1) ?? '').toLowerCase().trim();
      final body = match.group(2) ?? '';
      blocks.add(_visualFence(lang, body) ?? _markdown(context, theme, '```$lang\n$body```'));
      cursor = match.end;
    }
    if (cursor < source.length) {
      final tail = source.substring(cursor);
      if (tail.trim().isNotEmpty) blocks.add(_markdown(context, theme, tail));
    }
    if (blocks.isEmpty) blocks.add(_markdown(context, theme, source));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [for (var i = 0; i < blocks.length; i++) ...[if (i > 0) const SizedBox(height: 4), blocks[i]]]);
  }

  Widget? _visualFence(String lang, String body) => switch (lang) {
    'chart' => ChatChart.fromSource(body, textColor: textColor),
    'diagram' || 'mermaid' || 'flowchart' || 'graph' => ChatDiagram.fromSource(body, textColor: textColor),
    'table' => ChatFenceTable.fromSource(body, textColor: textColor),
    'user' => _ResourceCard(kind: '用户', refId: body.trim(), icon: Icons.person_outline, textColor: textColor, onTap: onResourceTap, onPreview: onResourcePreview),
    'cpost' => _ResourceCard(kind: 'cPost', refId: body.trim(), icon: Icons.article_outlined, textColor: textColor, onTap: onResourceTap, onPreview: onResourcePreview),
    'cshop' => _ResourceCard(kind: 'cShop', refId: body.trim(), icon: Icons.shopping_bag_outlined, textColor: textColor, onTap: onResourceTap, onPreview: onResourcePreview),
    _ => null,
  };

  Widget _markdown(BuildContext context, ThemeData theme, String data) {
    final codeBackground = textColor.withValues(alpha: 0.08);
    final resolvedLink = linkColor ?? theme.colorScheme.primary;
    final style = MarkdownStyleSheet(p: TextStyle(color: textColor, height: 1.45, fontSize: fontSize), a: TextStyle(color: resolvedLink, decoration: TextDecoration.underline), strong: TextStyle(color: textColor, fontWeight: FontWeight.w700), em: TextStyle(color: textColor, fontStyle: FontStyle.italic), code: TextStyle(color: textColor, fontSize: fontSize - 1.5, backgroundColor: codeBackground), codeblockPadding: const EdgeInsets.all(10), codeblockDecoration: BoxDecoration(color: codeBackground, borderRadius: BorderRadius.circular(8)), blockquote: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: fontSize), blockquoteDecoration: BoxDecoration(border: Border(left: BorderSide(color: textColor.withValues(alpha: 0.3), width: 3))), blockquotePadding: const EdgeInsets.only(left: 10, top: 2, bottom: 2), listBullet: TextStyle(color: textColor, fontSize: fontSize), listIndent: 18);
    return MarkdownBody(data: data, selectable: false, extensionSet: md.ExtensionSet.gitHubWeb, styleSheet: style, onTapLink: (text, href, title) => _onTapLink(context, href));
  }

  void _onTapLink(BuildContext context, String? href) {
    if (href == null || href.isEmpty) return;
    unawaited(Clipboard.setData(ClipboardData(text: href)));
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).chatCopied)));
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.kind, required this.refId, required this.icon, required this.textColor, this.onTap, this.onPreview});
  final String kind;
  final String refId;
  final IconData icon;
  final Color textColor;
  final Future<void> Function(String kind, int id)? onTap;
  final Future<Map<String, String>> Function(String kind, int id)? onPreview;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final valid = RegExp(r'^\d+$').hasMatch(refId);
    if (!valid) return _card(context, accent, const {'title': '内容 ID 不合法'});
    if (onPreview == null) return _card(context, accent, {'title': kind, 'subtitle': '点击查看详情 · ID：$refId'});
    return FutureBuilder<Map<String, String>>(
      future: onPreview!(kind, int.parse(refId)),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <String, String>{};
        if (snapshot.connectionState == ConnectionState.waiting && data.isEmpty) return _card(context, accent, {'title': kind, 'subtitle': '正在加载预览…'});
        return _card(context, accent, data.isEmpty ? {'title': kind, 'subtitle': '点击查看详情 · ID：$refId'} : data);
      },
    );
  }

  Widget _card(BuildContext context, Color accent, Map<String, String> data) {
    final valid = RegExp(r'^\d+$').hasMatch(refId);
    final cardTextColor = Theme.of(context).colorScheme.onSurface;
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outlineVariant), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(radius: 17, backgroundColor: accent.withValues(alpha: .16), child: Icon(icon, color: accent, size: 19)), const SizedBox(width: 10), Expanded(child: Text(data['title']?.isNotEmpty == true ? data['title']! : kind, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: cardTextColor, fontWeight: FontWeight.w700, fontSize: 15))), const Icon(Icons.chevron_right, size: 20)]),
        if ((data['subtitle'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(left: 44, top: 4), child: Text(data['subtitle']!, style: TextStyle(color: textColor.withValues(alpha: .72)))),
        if ((data['body'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(left: 44, top: 8), child: Text(data['body']!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColor.withValues(alpha: .85), height: 1.35))),
        if ((data['meta'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(left: 44, top: 8), child: Text(data['meta']!, style: TextStyle(color: accent, fontSize: 12))),
      ]),
    );
    if (!valid || onTap == null) return content;
    return InkWell(borderRadius: BorderRadius.circular(14), onTap: () => onTap!(kind, int.parse(refId)), child: content);
  }
}
