/// 系统教程（帮助中心）：后端 `GET /ai/system-guides` 的 v1 协议文档。
class SystemGuideSummary {
  const SystemGuideSummary({
    required this.guideKey,
    required this.module,
    required this.title,
    this.summary = '',
    this.revision = 0,
    this.kind = '',
  });

  final String guideKey;
  final String module;
  final String title;
  final String summary;
  final int revision;
  final String kind;

  factory SystemGuideSummary.fromJson(Map<String, dynamic> json) =>
      SystemGuideSummary(
        guideKey: (json['guide_key'] ?? '').toString(),
        module: (json['module'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        summary: (json['summary'] ?? '').toString(),
        revision: json['revision'] is num ? (json['revision'] as num).toInt() : 0,
        kind: (json['kind'] ?? '').toString(),
      );
}

class SystemGuideStep {
  const SystemGuideStep({
    required this.id,
    required this.title,
    required this.description,
    this.actionTarget,
    this.actionLabel,
  });

  final String id;
  final String title;
  final String description;

  /// 仅支持 `navigate` 类型动作，target 由后端白名单校验。
  final String? actionTarget;
  final String? actionLabel;

  factory SystemGuideStep.fromJson(Map<String, dynamic> json) {
    final action = json['action'];
    String? target;
    String? label;
    if (action is Map) {
      target = action['target']?.toString();
      label = action['label']?.toString();
    }
    return SystemGuideStep(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      actionTarget: target,
      actionLabel: label,
    );
  }
}

class SystemGuideTroubleshooting {
  const SystemGuideTroubleshooting({
    required this.symptom,
    this.checks = const [],
    this.resolution = const [],
  });

  final String symptom;
  final List<String> checks;
  final List<String> resolution;

  factory SystemGuideTroubleshooting.fromJson(Map<String, dynamic> json) =>
      SystemGuideTroubleshooting(
        symptom: (json['symptom'] ?? '').toString(),
        checks: _strings(json['checks']),
        resolution: _strings(json['resolution']),
      );
}

class SystemGuide {
  const SystemGuide({
    required this.guideKey,
    required this.module,
    required this.title,
    this.summary = '',
    this.kind = '',
    this.revision = 0,
    this.appliesTo = const [],
    this.requirements = const [],
    this.steps = const [],
    this.troubleshooting = const [],
    this.relatedGuides = const [],
  });

  final String guideKey;
  final String module;
  final String title;
  final String summary;
  final String kind;
  final int revision;
  final List<String> appliesTo;
  final List<String> requirements;
  final List<SystemGuideStep> steps;
  final List<SystemGuideTroubleshooting> troubleshooting;
  final List<String> relatedGuides;

  factory SystemGuide.fromJson(Map<String, dynamic> json) => SystemGuide(
    guideKey: (json['guide_key'] ?? '').toString(),
    module: (json['module'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    summary: (json['summary'] ?? '').toString(),
    kind: (json['kind'] ?? '').toString(),
    revision: json['revision'] is num ? (json['revision'] as num).toInt() : 0,
    appliesTo: _strings(json['applies_to']),
    requirements: _strings(json['requirements']),
    steps:
        (json['steps'] is List ? json['steps'] as List : const [])
            .whereType<Map>()
            .map((item) => SystemGuideStep.fromJson(Map<String, dynamic>.from(item)))
            .toList(),
    troubleshooting:
        (json['troubleshooting'] is List ? json['troubleshooting'] as List : const [])
            .whereType<Map>()
            .map(
              (item) => SystemGuideTroubleshooting.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(),
    relatedGuides: _strings(json['related_guides']),
  );
}

List<String> _strings(Object? value) {
  if (value is! List) return const [];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
