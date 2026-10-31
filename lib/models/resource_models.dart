import 'dart:convert';

/// 资料库文档（`GET /ai/knowledge/list`）。
class KnowledgeDoc {
  const KnowledgeDoc({
    required this.docId,
    this.collection = '',
    this.fileUrl = '',
    this.fileName = '',
    this.fileType = '',
    this.contentDate = '',
    this.resourceKind = '',
    this.status = '',
    this.createdAt,
    this.createdBy,
    this.errorMsg = '',
    this.sourceImages = const [],
  });

  final int docId;
  final String collection;
  final String fileUrl;
  final String fileName;
  final String fileType;
  final String contentDate;
  final String resourceKind;
  final String status;
  final DateTime? createdAt;
  final int? createdBy;
  final String errorMsg;
  final List<String> sourceImages;

  bool get isReady => status == 'success';

  /// 资料日期优先，缺失时退回创建日期。
  String get displayDate {
    if (contentDate.trim().isNotEmpty) return contentDate.trim();
    final created = createdAt;
    if (created == null) return '';
    final local = created.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  bool get isImage => fileType.toLowerCase() == 'png' || fileType.toLowerCase() == 'jpg' || fileType.toLowerCase() == 'jpeg';

  /// 缩略图：优先资料内嵌图片，其次图片型资料本身。
  String? get thumbnail {
    for (final url in sourceImages) {
      if (url.trim().isNotEmpty) return url;
    }
    if (isImage && fileUrl.isNotEmpty) return fileUrl;
    return null;
  }

  /// 列表分类：all/doc/md/docx/pptx/pdf/sheet/image。
  String get category {
    final type = fileType.toLowerCase();
    if (type == 'md' || type == 'markdown') return 'md';
    if (type == 'docx' || type == 'doc') return 'doc';
    if (type == 'pptx' || type == 'ppt') return 'pptx';
    if (type == 'pdf') return 'pdf';
    if (type == 'xlsx' || type == 'xls' || type == 'csv') return 'sheet';
    if (type == 'png' || type == 'jpg' || type == 'jpeg' || type == 'gif' || type == 'webp') {
      return 'image';
    }
    return 'doc';
  }

  factory KnowledgeDoc.fromJson(Map<String, dynamic> json) => KnowledgeDoc(
    docId: json['docId'] is num ? (json['docId'] as num).toInt() : 0,
    collection: (json['collection'] ?? '').toString(),
    fileUrl: (json['fileUrl'] ?? '').toString(),
    fileName: (json['fileName'] ?? '').toString(),
    fileType: (json['fileType'] ?? '').toString(),
    contentDate: (json['contentDate'] ?? '').toString(),
    resourceKind: (json['resourceKind'] ?? '').toString(),
    status: (json['status'] ?? '').toString(),
    createdAt: _date(json['createdAt']),
    createdBy: json['createdBy'] is num ? (json['createdBy'] as num).toInt() : null,
    errorMsg: (json['errorMsg'] ?? '').toString(),
    sourceImages: _sourceImageUrls(json['sourceImages']),
  );
}

/// `sourceImages` 是 JSON 字符串数组，元素形如 `{file_id, url}`。
List<String> _sourceImageUrls(Object? value) {
  dynamic decoded = value;
  if (value is String && value.trim().isNotEmpty) {
    try {
      decoded = value.trim().startsWith('[') ? _decodeJsonArray(value) : null;
    } catch (_) {
      decoded = null;
    }
  }
  if (decoded is! List) return const [];
  final urls = <String>[];
  for (final item in decoded) {
    if (item is Map) {
      final url = item['url']?.toString().trim();
      if (url != null && url.isNotEmpty) urls.add(url);
    } else if (item is String && item.trim().isNotEmpty) {
      urls.add(item.trim());
    }
  }
  return urls;
}

List<dynamic> _decodeJsonArray(String raw) {
  var text = raw.trim();
  // 容忍被二次转义的字符串。
  if (text.startsWith('"') && text.endsWith('"')) {
    text = text.substring(1, text.length - 1).replaceAll(r'\"', '"');
  }
  try {
    final decoded = jsonDecode(text);
    return decoded is List ? decoded : const [];
  } on FormatException {
    return const [];
  }
}
/// 图库按天聚合。
class GalleryDay {
  const GalleryDay({
    required this.day,
    this.label = '',
    this.short = '',
    this.count = 0,
    this.cover = '',
    this.items = const [],
  });

  final String day;
  final String label;
  final String short;
  final int count;
  final String cover;
  final List<GalleryPhoto> items;

  factory GalleryDay.fromJson(Map<String, dynamic> json) => GalleryDay(
    day: (json['day'] ?? '').toString(),
    label: (json['label'] ?? '').toString(),
    short: (json['short'] ?? '').toString(),
    count: json['count'] is num ? (json['count'] as num).toInt() : 0,
    cover: (json['cover'] ?? '').toString(),
    items:
        (json['items'] is List ? json['items'] as List : const [])
            .whereType<Map<String, dynamic>>()
            .map(GalleryPhoto.fromJson)
            .toList(),
  );
}

class GalleryIndex {
  const GalleryIndex({this.total = 0, this.days = const []});

  final int total;
  final List<GalleryDay> days;

  factory GalleryIndex.fromJson(Map<String, dynamic> json) => GalleryIndex(
    total: json['total'] is num ? (json['total'] as num).toInt() : 0,
    days:
        (json['days'] is List ? json['days'] as List : const [])
            .whereType<Map<String, dynamic>>()
            .map(GalleryDay.fromJson)
            .toList(),
  );
}

class GalleryPhoto {
  const GalleryPhoto({required this.id, this.name = '', this.url = '', this.size = 0});

  final int id;
  final String name;
  final String url;
  final int size;

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) => GalleryPhoto(
    id: json['id'] is num ? (json['id'] as num).toInt() : 0,
    name: (json['name'] ?? '').toString(),
    url: (json['url'] ?? '').toString(),
    size: json['size'] is num ? (json['size'] as num).toInt() : 0,
  );
}

/// 经验库条目（`GET /ai/experience/library`）。
class ExperienceRecord {
  const ExperienceRecord({
    required this.id,
    this.scene = 'normal',
    this.skill = '',
    this.polarity = 1,
    this.pattern = '',
    this.rule = '',
  });

  final int id;
  final String scene;
  final String skill;
  final int polarity;
  final String pattern;
  final String rule;

  factory ExperienceRecord.fromJson(Map<String, dynamic> json) => ExperienceRecord(
    id: json['id'] is num ? (json['id'] as num).toInt() : 0,
    scene: (json['scene'] ?? 'normal').toString(),
    skill: (json['skill'] ?? '').toString(),
    polarity: json['polarity'] is num ? (json['polarity'] as num).toInt() : 1,
    pattern: (json['pattern'] ?? '').toString(),
    rule: (json['rule'] ?? '').toString(),
  );
}

class ExperiencePage {
  const ExperiencePage({required this.records, required this.total});

  final List<ExperienceRecord> records;
  final int total;

  factory ExperiencePage.fromJson(Map<String, dynamic> json) => ExperiencePage(
    records:
        (json['records'] is List ? json['records'] as List : const [])
            .whereType<Map<String, dynamic>>()
            .map(ExperienceRecord.fromJson)
            .toList(),
    total: json['total'] is num ? (json['total'] as num).toInt() : 0,
  );
}

DateTime? _date(Object? value) {
  if (value == null) return null;
  if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  return DateTime.tryParse(value.toString());
}
