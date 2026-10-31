import 'dart:convert';

import 'package:flutter/material.dart';

/// 数据类围栏：```timeline、```table、```tree。
///
/// 协议照后端 `fence_registry.json` + `web/src/utils/dataFence.js`：都要求
/// `version: 1`，字段长度上限与错误文案保持一致，渲染失败时回退源码。
class AiFenceResult<T> {
  const AiFenceResult.ok(this.data) : error = '';

  const AiFenceResult.fail(this.error) : data = null;

  final T? data;
  final String error;

  bool get isOk => data != null;
}

class _Fail implements Exception {
  const _Fail(this.message);

  final String message;
}

Never _fail(String message) => throw _Fail(message);

Map<String, dynamic> _object(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return _fail('内容必须为 JSON 对象');
}

bool _isNumber(Object? value) => value is num && value.isFinite;

String _text(Object? value, String name, {bool optional = false}) {
  if (value == null && optional) return '';
  if (value is! String || value.length > 4000 || (!optional && value.trim().isEmpty)) {
    _fail('$name 需要非空文字（最多4000字符）');
  }
  return value;
}

List<dynamic> _list(Object? value, int max, String name) {
  if (value is List && value.length <= max) return value;
  return _fail('$name 需要数组，最多$max项');
}

// ————————————————————————— timeline —————————————————————————

class AiTimelineEvent {
  const AiTimelineEvent({
    required this.id,
    required this.title,
    required this.time,
    required this.timeType,
    required this.status,
    required this.description,
  });

  final String id;
  final String title;
  final String time;
  final String timeType;
  final String status;
  final String description;

  String get timeTypeLabel => switch (timeType) {
    'actual' => '实际',
    'planned' => '计划',
    _ => '估计',
  };

  String get statusLabel => switch (status) {
    'done' => '已完成',
    'active' => '进行中',
    _ => '待进行',
  };
}

class AiTimelineData {
  const AiTimelineData({
    required this.title,
    required this.description,
    required this.source,
    required this.events,
  });

  final String title;
  final String description;
  final String source;
  final List<AiTimelineEvent> events;

  static AiFenceResult<AiTimelineData> parse(String content) {
    try {
      if (content.length > 500000) _fail('内容超过500KB，请拆分');
      Object? decoded;
      try {
        decoded = jsonDecode(content);
      } on FormatException {
        _fail('JSON 格式无效');
      }
      final root = _object(decoded);
      if (root['version'] != 1 && root['version'] != 1.0) _fail('version 必须为 1');
      final ids = <String>{};
      final rawEvents = _list(root['events'], 300, 'events');
      final events = <AiTimelineEvent>[];
      for (final item in rawEvents) {
        final map = _object(item);
        final id = _text(map['id'], 'id');
        if (!ids.add(id)) _fail('id 不能重复');
        final timeType = map['timeType'];
        if (timeType != 'actual' && timeType != 'planned' && timeType != 'estimated') {
          _fail('timeType 必须为 actual/planned/estimated，明确实际/计划/估计');
        }
        final status = map['status'] ?? 'pending';
        if (status != 'done' && status != 'active' && status != 'pending') {
          _fail('status 不支持');
        }
        events.add(
          AiTimelineEvent(
            id: id,
            title: _text(map['title'], '事件 title'),
            time: _text(map['time'], 'time'),
            timeType: timeType as String,
            status: status as String,
            description: _text(map['description'], 'description', optional: true),
          ),
        );
      }
      if (events.isEmpty) _fail('至少需要一个事件');
      return AiFenceResult.ok(
        AiTimelineData(
          title: _text(root['title'], 'title', optional: true),
          description: _text(root['description'], 'description', optional: true),
          source: _text(root['source'], 'source', optional: true),
          events: events,
        ),
      );
    } on _Fail catch (error) {
      return AiFenceResult.fail(error.message);
    }
  }
}

// ————————————————————————— table —————————————————————————

class AiTableColumn {
  const AiTableColumn({
    required this.key,
    required this.label,
    required this.type,
    required this.unit,
  });

  final String key;
  final String label;
  final String type;
  final String unit;

  bool get isNumber => type == 'number';
}

class AiTableData {
  const AiTableData({
    required this.title,
    required this.description,
    required this.source,
    required this.methodology,
    required this.columns,
    required this.rows,
  });

  final String title;
  final String description;
  final String source;
  final String methodology;
  final List<AiTableColumn> columns;
  final List<Map<String, Object?>> rows;

  static AiFenceResult<AiTableData> parse(String content) {
    try {
      if (content.length > 500000) _fail('内容超过500KB，请拆分');
      Object? decoded;
      try {
        decoded = jsonDecode(content);
      } on FormatException {
        _fail('JSON 格式无效');
      }
      final root = _object(decoded);
      if (root['version'] != 1 && root['version'] != 1.0) _fail('version 必须为 1');
      final keys = <String>{};
      final columns = <AiTableColumn>[];
      for (final item in _list(root['columns'], 30, 'columns')) {
        final map = _object(item);
        final key = _text(map['key'], '列 key');
        if (!keys.add(key) || key == '__proto__' || key == 'constructor' || key == 'prototype') {
          _fail('列 key 重复或不可用');
        }
        final type = (map['type'] ?? 'text').toString();
        if (!const ['text', 'number', 'date', 'boolean'].contains(type)) {
          _fail('列 type 不支持');
        }
        columns.add(
          AiTableColumn(
            key: key,
            label: _text(map['label'], '列 label'),
            type: type,
            unit: _text(map['unit'], 'unit', optional: true),
          ),
        );
      }
      if (columns.isEmpty) _fail('至少需要一列');
      final rows = <Map<String, Object?>>[];
      final rawRows = _list(root['rows'], 5000, 'rows');
      for (var i = 0; i < rawRows.length; i++) {
        final map = _object(rawRows[i]);
        final row = <String, Object?>{};
        for (final column in columns) {
          final value = map[column.key];
          if (value == null) {
            row[column.key] = null;
            continue;
          }
          switch (column.type) {
            case 'number':
              if (!_isNumber(value)) _fail('第${i + 1}行 ${column.label} 类型应为 number');
            case 'boolean':
              if (value is! bool) _fail('第${i + 1}行 ${column.label} 类型应为 boolean');
            case 'date':
              if (value is! String ||
                  (value.length > 4000) ||
                  !RegExp(r'^\d{4}-\d{2}-\d{2}(?:T.*)?$').hasMatch(value)) {
                _fail('日期使用 YYYY-MM-DD 或 ISO 时间');
              }
            default:
              if (value is! String) _fail('第${i + 1}行 ${column.label} 类型应为 text');
              if (value.length > 4000) _fail('单元格文字过长');
          }
          row[column.key] = value as Object?;
        }
        rows.add(row);
      }
      return AiFenceResult.ok(
        AiTableData(
          title: _text(root['title'], 'title', optional: true),
          description: _text(root['description'], 'description', optional: true),
          source: _text(root['source'], 'source', optional: true),
          methodology: _text(root['methodology'], 'methodology', optional: true),
          columns: columns,
          rows: rows,
        ),
      );
    } on _Fail catch (error) {
      return AiFenceResult.fail(error.message);
    }
  }
}

// ————————————————————————— tree —————————————————————————

class AiTreeNode {
  const AiTreeNode({
    required this.id,
    required this.label,
    required this.description,
    required this.kind,
    required this.children,
  });

  final String id;
  final String label;
  final String description;
  final String kind;
  final List<AiTreeNode> children;
}

class AiTreeData {
  const AiTreeData({
    required this.title,
    required this.description,
    required this.source,
    required this.nodes,
  });

  final String title;
  final String description;
  final String source;
  final List<AiTreeNode> nodes;

  static AiFenceResult<AiTreeData> parse(String content) {
    try {
      if (content.length > 500000) _fail('内容超过500KB，请拆分');
      Object? decoded;
      try {
        decoded = jsonDecode(content);
      } on FormatException {
        _fail('JSON 格式无效');
      }
      final root = _object(decoded);
      if (root['version'] != 1 && root['version'] != 1.0) _fail('version 必须为 1');
      final ids = <String>{};
      var count = 0;
      List<AiTreeNode> walk(Object? value, int depth) {
        if (depth > 12) _fail('层级最多12层');
        final nodes = <AiTreeNode>[];
        for (final item in _list(value, 500, 'nodes/children')) {
          if (++count > 500) _fail('节点最多500个');
          final map = _object(item);
          final id = _text(map['id'], 'id');
          if (!ids.add(id)) _fail('id 不能重复');
          final kind = (map['kind'] ?? 'item').toString();
          if (!const ['folder', 'file', 'module', 'class', 'item'].contains(kind)) {
            _fail('节点 kind 不支持');
          }
          final children = map['children'];
          if (children != null && children is! List) _fail('children 需要数组');
          nodes.add(
            AiTreeNode(
              id: id,
              label: _text(map['label'], '节点 label'),
              description: _text(map['description'], 'description', optional: true),
              kind: kind,
              children: children is List && children.isNotEmpty ? walk(children, depth + 1) : const [],
            ),
          );
        }
        return nodes;
      }

      final nodes = walk(root['nodes'], 1);
      if (nodes.isEmpty) _fail('至少需要一个节点');
      return AiFenceResult.ok(
        AiTreeData(
          title: _text(root['title'], 'title', optional: true),
          description: _text(root['description'], 'description', optional: true),
          source: _text(root['source'], 'source', optional: true),
          nodes: nodes,
        ),
      );
    } on _Fail catch (error) {
      return AiFenceResult.fail(error.message);
    }
  }
}

// ————————————————————————— 渲染 —————————————————————————

const _ink = Color(0xFF395236);
const _muted = Color(0xFF6A7A60);
const _line = Color(0xFFDCE5D2);

/// ```timeline / ```table / ```tree 的统一卡片。
class AiDataFenceCard extends StatelessWidget {
  const AiDataFenceCard({super.key, required this.type, required this.source});

  final String type;
  final String source;

  @override
  Widget build(BuildContext context) {
    final (Widget? body, String error) = switch (type) {
      'timeline' => _timeline(),
      'table' => _table(),
      'tree' => _tree(),
      _ => (null, '未接入的数据展示类型'),
    };
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: error.isNotEmpty
          ? _errorBox(error)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [body!],
            ),
    );
  }

  (Widget?, String) _timeline() {
    final result = AiTimelineData.parse(source);
    final data = result.data;
    if (data == null) return (null, result.error);
    return (
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _intro(data.title, data.description, '时间线'),
          for (final event in data.events) _timelineRow(event),
          if (data.source.isNotEmpty) _note('来源说明：${data.source}'),
        ],
      ),
      '',
    );
  }

  Widget _timelineRow(AiTimelineEvent event) {
    final dot = event.status == 'active'
        ? const Color(0xFF5E8550)
        : const Color(0xFF9AB67C);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.time,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF5A724D)),
                  ),
                  Text(
                    event.timeTypeLabel,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF7C896E)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4, bottom: 6),
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 14),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFBECDAD))),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -21,
                    top: 8,
                    child: Transform.rotate(
                      angle: 0.785,
                      child: Container(width: 7, height: 7, color: dot),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              event.statusLabel,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF748267)),
                            ),
                          ),
                        ],
                      ),
                      if (event.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.7,
                              color: Color(0xFF5F7057),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Widget?, String) _table() {
    final result = AiTableData.parse(source);
    final data = result.data;
    if (data == null) return (null, result.error);
    final rows = data.rows.take(200).toList();
    return (
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _intro(data.title, data.description, '数据表'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF4E5)),
              headingTextStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
              dataTextStyle: const TextStyle(fontSize: 12.5, color: _ink),
              columnSpacing: 22,
              horizontalMargin: 10,
              columns: [
                for (final column in data.columns)
                  DataColumn(
                    numeric: column.isNumber,
                    label: Text(
                      column.unit.isEmpty ? column.label : '${column.label} / ${column.unit}',
                    ),
                  ),
              ],
              rows: [
                for (var i = 0; i < rows.length; i++)
                  DataRow(
                    color: WidgetStateProperty.all(
                      i.isOdd ? const Color(0xFFF7F9EF) : Colors.transparent,
                    ),
                    cells: [
                      for (final column in data.columns)
                        DataCell(Text(_cellText(rows[i][column.key]))),
                    ],
                  ),
              ],
            ),
          ),
          if (data.rows.length > rows.length)
            _note('仅显示前 ${rows.length} / ${data.rows.length} 行'),
          if (data.methodology.isNotEmpty) _note('统计口径：${data.methodology}'),
          if (data.source.isNotEmpty) _note('来源说明：${data.source}'),
          if (data.rows.isEmpty) _note('没有匹配的数据'),
        ],
      ),
      '',
    );
  }

  String _cellText(Object? value) {
    if (value == null) return '—';
    if (value is bool) return value ? '是' : '否';
    return value.toString();
  }

  (Widget?, String) _tree() {
    final result = AiTreeData.parse(source);
    final data = result.data;
    if (data == null) return (null, result.error);
    return (
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _intro(data.title, data.description, '层级结构'),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final node in data.nodes) _treeNode(node)],
            ),
          ),
          if (data.source.isNotEmpty) _note('来源说明：${data.source}'),
        ],
      ),
      '',
    );
  }

  Widget _treeNode(AiTreeNode node) {
    final icon = switch (node.kind) {
      'folder' => Icons.folder_outlined,
      'file' => Icons.insert_drive_file_outlined,
      'module' => Icons.widgets_outlined,
      'class' => Icons.account_tree_outlined,
      _ => Icons.circle_outlined,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 15, color: _muted),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.label,
                      style: const TextStyle(fontSize: 13, color: _ink),
                    ),
                    if (node.description.isNotEmpty)
                      Text(
                        node.description,
                        style: const TextStyle(fontSize: 11.5, color: _muted),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (node.children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final child in node.children) _treeNode(child)],
              ),
            ),
        ],
      ),
    );
  }

  Widget _intro(String title, String description, String fallback) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? fallback : title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: const TextStyle(fontSize: 12.5, height: 1.6, color: _muted),
              ),
            ),
        ],
      ),
    );
  }

  Widget _note(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE1E8D8)))),
    child: Text(message, style: const TextStyle(fontSize: 11.5, color: Color(0xFF65765B))),
  );

  Widget _errorBox(String error) => Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '无法渲染：$error',
          style: const TextStyle(fontSize: 13, color: Color(0xFF934737)),
        ),
        const SizedBox(height: 8),
        SelectableText(
          source.trimRight(),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.5),
        ),
      ],
    ),
  );
}
