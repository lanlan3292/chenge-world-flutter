import 'dart:convert';

import 'package:flutter/material.dart';

/// AI 输出的 ```history fenced JSON（史官档案），按 web HistoryArchive 的结构精简渲染。
class AiHistoryArchive {
  const AiHistoryArchive({
    required this.title,
    required this.summary,
    required this.resultType,
    required this.schemaVersion,
    this.entities = const [],
    this.events = const [],
    this.relations = const [],
    this.evidence = const [],
    this.disputes = const [],
    this.openQuestions = const [],
  });

  final String title;
  final String summary;
  final String resultType;
  final String schemaVersion;
  final List<AiHistoryEntity> entities;
  final List<AiHistoryEvent> events;
  final List<AiHistoryRelation> relations;
  final List<AiEvidence> evidence;
  final List<AiHistoryDispute> disputes;
  final List<String> openQuestions;

  String get resultLabel {
    switch (resultType) {
      case 'profile':
        return '对象档案';
      case 'event':
        return '事件考证';
      case 'verification':
        return '专题查证';
      default:
        return '历史沿革';
    }
  }

  factory AiHistoryArchive.parse(String source) {
    dynamic decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const FormatException('JSON 格式无效');
    }
    if (decoded is! Map) throw const FormatException('内容必须为 JSON 对象');
    final version = (decoded['schema_version'] ?? '').toString();
    if (version != '1.0') throw const FormatException('schema_version 必须为字符串 "1.0"');
    List<Map<String, dynamic>> maps(String key) =>
        (decoded[key] is List ? decoded[key] as List : const [])
            .whereType<Map<String, dynamic>>()
            .toList();
    return AiHistoryArchive(
      title: (decoded['title'] ?? '').toString(),
      summary: (decoded['summary'] ?? '').toString(),
      resultType: (decoded['result_type'] ?? 'history').toString(),
      schemaVersion: version,
      entities: maps('entities').map(AiHistoryEntity.fromJson).toList(),
      events: maps('events').map(AiHistoryEvent.fromJson).toList(),
      relations: maps('relations').map(AiHistoryRelation.fromJson).toList(),
      evidence: maps('evidence').map(AiEvidence.fromJson).toList(),
      disputes: maps('disputes').map(AiHistoryDispute.fromJson).toList(),
      openQuestions: [
        for (final item in (decoded['open_questions'] is List
            ? decoded['open_questions'] as List
            : const []))
          if (item != null) item.toString(),
      ],
    );
  }
}

class AiHistoryEntity {
  const AiHistoryEntity({
    required this.id,
    required this.name,
    this.type = '',
    this.summary = '',
    this.aliases = const [],
    this.facts = const [],
  });

  final String id;
  final String name;
  final String type;
  final String summary;
  final List<String> aliases;
  final List<AiHistoryFact> facts;

  factory AiHistoryEntity.fromJson(Map<String, dynamic> json) => AiHistoryEntity(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    type: (json['type'] ?? '').toString(),
    summary: (json['summary'] ?? '').toString(),
    aliases: [for (final alias in (json['aliases'] is List ? json['aliases'] as List : const [])) alias.toString()],
    facts: (json['facts'] is List ? json['facts'] as List : const [])
        .whereType<Map<String, dynamic>>()
        .map(AiHistoryFact.fromJson)
        .toList(),
  );
}

class AiHistoryFact {
  const AiHistoryFact({this.label = '', this.value = ''});

  final String label;
  final String value;

  factory AiHistoryFact.fromJson(Map<String, dynamic> json) => AiHistoryFact(
    label: (json['label'] ?? '').toString(),
    value: (json['value'] ?? '').toString(),
  );
}

class AiHistoryEvent {
  const AiHistoryEvent({
    required this.id,
    required this.title,
    this.description = '',
    this.status = 'recorded',
    this.timeText = '',
    this.reasoning = '',
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final String timeText;
  final String reasoning;

  String get statusLabel {
    switch (status) {
      case 'inferred':
        return '推断';
      case 'disputed':
        return '有争议';
      default:
        return '有记载';
    }
  }

  factory AiHistoryEvent.fromJson(Map<String, dynamic> json) {
    final time = json['time'];
    var timeText = '';
    if (time is Map) {
      timeText = (time['display'] ?? time['start'] ?? '').toString();
    } else if (time is String) {
      timeText = time;
    }
    return AiHistoryEvent(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? 'recorded').toString(),
      timeText: timeText,
      reasoning: (json['reasoning'] ?? '').toString(),
    );
  }
}

class AiHistoryRelation {
  const AiHistoryRelation({this.label = '', this.type = '', this.description = ''});

  final String label;
  final String type;
  final String description;

  factory AiHistoryRelation.fromJson(Map<String, dynamic> json) => AiHistoryRelation(
    label: (json['label'] ?? '').toString(),
    type: (json['type'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
  );
}

class AiEvidence {
  const AiEvidence({this.title = '', this.quote = '', this.sourceType = '', this.locator = ''});

  final String title;
  final String quote;
  final String sourceType;
  final String locator;

  factory AiEvidence.fromJson(Map<String, dynamic> json) => AiEvidence(
    title: (json['title'] ?? '').toString(),
    quote: (json['quote'] ?? '').toString(),
    sourceType: (json['source_type'] ?? '').toString(),
    locator: (json['locator'] ?? '').toString(),
  );
}

class AiHistoryDispute {
  const AiHistoryDispute({this.title = '', this.claims = const [], this.resolution = ''});

  final String title;
  final List<String> claims;
  final String resolution;

  factory AiHistoryDispute.fromJson(Map<String, dynamic> json) => AiHistoryDispute(
    title: (json['title'] ?? '').toString(),
    claims: [
      for (final claim in (json['claims'] is List ? json['claims'] as List : const []))
        if (claim is Map && claim['text'] != null) claim['text'].toString(),
    ],
    resolution: (json['resolution'] ?? '').toString(),
  );
}

/// 史官档案卡片。
class AiHistoryCard extends StatefulWidget {
  const AiHistoryCard({super.key, required this.source});

  final String source;

  @override
  State<AiHistoryCard> createState() => _AiHistoryCardState();
}

class _AiHistoryCardState extends State<AiHistoryCard> {
  bool _showSource = false;

  @override
  Widget build(BuildContext context) {
    AiHistoryArchive? archive;
    String? error;
    try {
      archive = AiHistoryArchive.parse(widget.source);
    } on FormatException catch (formatError) {
      error = formatError.message;
    }
    if (error != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1E5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2DBC6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '无法展示：$error',
              style: const TextStyle(color: Color(0xFFB3261E), fontSize: 12.5),
            ),
            if (_showSource)
              SelectableText(
                widget.source,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            TextButton(
              onPressed: () => setState(() => _showSource = !_showSource),
              child: Text(_showSource ? '收起源码' : '查看源码'),
            ),
          ],
        ),
      );
    }

    final data = archive!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2DBC6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${data.resultLabel} · 史料考证',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF7A6A4F), fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _showSource = !_showSource),
                child: Text(_showSource ? '返回档案' : '查看源码'),
              ),
            ],
          ),
          Text(
            data.title.isEmpty ? '史料考证' : data.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          if (data.summary.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(data.summary, style: const TextStyle(fontSize: 13, height: 1.55)),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _pill('${data.entities.length} 个对象'),
              _pill('${data.events.length} 件事迹'),
              _pill('${data.evidence.length} 份引证'),
              if (data.disputes.isNotEmpty) _pill('${data.disputes.length} 项分歧'),
            ],
          ),
          if (_showSource)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              color: const Color(0xFFEFEAD8),
              child: SelectableText(
                widget.source,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          if (!_showSource) ...[
            if (data.events.isNotEmpty) ...[
              const SizedBox(height: 12),
              _section('时间线'),
              for (final event in data.events) _eventTile(event),
            ],
            if (data.entities.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section('实体档案'),
              for (final entity in data.entities) _entityTile(entity),
            ],
            if (data.relations.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section('实体关系'),
              for (final relation in data.relations)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    [relation.label, relation.type, relation.description]
                        .where((part) => part.isNotEmpty)
                        .join(' · '),
                    style: const TextStyle(fontSize: 12.5, height: 1.45),
                  ),
                ),
            ],
            if (data.disputes.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section('记载分歧'),
              for (final dispute in data.disputes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dispute.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      for (final claim in dispute.claims)
                        Text('· $claim', style: const TextStyle(fontSize: 12, height: 1.45)),
                      if (dispute.resolution.isNotEmpty)
                        Text(
                          dispute.resolution,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B5A3E)),
                        ),
                    ],
                  ),
                ),
            ],
            if (data.openQuestions.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section('待考问题'),
              for (final question in data.openQuestions)
                Text('· $question', style: const TextStyle(fontSize: 12, height: 1.45)),
            ],
            if (data.evidence.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section('证据目录 · ${data.evidence.length}'),
              for (final evidence in data.evidence)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evidence.title.isEmpty ? evidence.sourceType : evidence.title,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      if (evidence.quote.isNotEmpty)
                        Text(
                          '“${evidence.quote}”',
                          style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF4A4030)),
                        ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
  );

  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFE7E0CB),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(text, style: const TextStyle(fontSize: 10.5, color: Color(0xFF5C4C34))),
  );

  Widget _eventTile(AiHistoryEvent event) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xFFEFEAD8),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
            Text(
              event.statusLabel,
              style: const TextStyle(fontSize: 10, color: Color(0xFF7A6A4F)),
            ),
          ],
        ),
        if (event.timeText.isNotEmpty)
          Text(event.timeText, style: const TextStyle(fontSize: 11, color: Color(0xFF7A6A4F))),
        if (event.description.isNotEmpty)
          Text(event.description, style: const TextStyle(fontSize: 12, height: 1.45)),
        if (event.reasoning.isNotEmpty)
          Text(
            '推断依据：${event.reasoning}',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B5A3E)),
          ),
      ],
    ),
  );

  Widget _entityTile(AiHistoryEntity entity) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          [entity.name, entity.type].where((part) => part.isNotEmpty).join(' · '),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
        ),
        if (entity.aliases.isNotEmpty)
          Text(
            '别名：${entity.aliases.join('、')}',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A6A4F)),
          ),
        if (entity.summary.isNotEmpty)
          Text(entity.summary, style: const TextStyle(fontSize: 12, height: 1.45)),
        for (final fact in entity.facts)
          Text(
            '${fact.label}：${fact.value}',
            style: const TextStyle(fontSize: 11.5, height: 1.4),
          ),
      ],
    ),
  );
}
