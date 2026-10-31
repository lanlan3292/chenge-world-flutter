/// AI 会话技能（`GET /ai/skills?session_id=`）。
class AiSkill {
  const AiSkill({
    required this.key,
    required this.name,
    this.description = '',
    this.source = 'local',
    this.enabled = false,
    this.itemId,
  });

  final String key;
  final String name;
  final String description;
  final String source;
  final bool enabled;
  final int? itemId;

  bool get isPurchased => source == 'purchased';

  AiSkill copyWith({bool? enabled}) => AiSkill(
    key: key,
    name: name,
    description: description,
    source: source,
    enabled: enabled ?? this.enabled,
    itemId: itemId,
  );

  factory AiSkill.fromJson(Map<String, dynamic> json) => AiSkill(
    key: (json['key'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
    source: (json['source'] ?? 'local').toString(),
    enabled: json['enabled'] == true,
    itemId: json['itemId'] is num ? (json['itemId'] as num).toInt() : null,
  );
}

/// SSE `interaction` 事件里的任务项。
class AiTaskItem {
  const AiTaskItem({
    required this.id,
    required this.title,
    this.detail = '',
    this.status = 'pending',
  });

  final String id;
  final String title;
  final String detail;
  final String status;

  AiTaskItem copyWith({String? status}) => AiTaskItem(
    id: id,
    title: title,
    detail: detail,
    status: status ?? this.status,
  );

  factory AiTaskItem.fromJson(Map<String, dynamic> json) => AiTaskItem(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    detail: (json['detail'] ?? '').toString(),
    status: (json['status'] ?? 'pending').toString(),
  );
}

class AiInteractionQuestion {
  const AiInteractionQuestion({
    required this.id,
    required this.question,
    this.options = const [],
    this.multiple = false,
    this.customLabel = '自行回答',
  });

  final String id;
  final String question;
  final List<String> options;
  final bool multiple;
  final String customLabel;

  factory AiInteractionQuestion.fromJson(Map<String, dynamic> json) => AiInteractionQuestion(
    id: (json['id'] ?? '').toString(),
    question: (json['question'] ?? '').toString(),
    options: [
      for (final option in (json['options'] is List ? json['options'] as List : const []))
        option.toString(),
    ],
    multiple: json['multiple'] == true,
    customLabel: (json['customLabel'] ?? '自行回答').toString(),
  );
}

class AiInteraction {
  const AiInteraction({
    required this.id,
    this.sessionId = '',
    this.mode = 'chat',
    this.status = 'pending',
    this.tasks = const [],
    this.questions = const [],
  });

  final String id;
  final String sessionId;
  final String mode;
  final String status;
  final List<AiTaskItem> tasks;
  final List<AiInteractionQuestion> questions;

  AiInteraction copyWith({String? status, List<AiTaskItem>? tasks}) => AiInteraction(
    id: id,
    sessionId: sessionId,
    mode: mode,
    status: status ?? this.status,
    tasks: tasks ?? this.tasks,
    questions: questions,
  );

  factory AiInteraction.fromJson(Map<String, dynamic> json) => AiInteraction(
    id: (json['id'] ?? '').toString(),
    sessionId: (json['sessionId'] ?? '').toString(),
    mode: (json['mode'] ?? 'chat').toString(),
    status: (json['status'] ?? 'pending').toString(),
    tasks: (json['tasks'] is List ? json['tasks'] as List : const [])
        .whereType<Map<String, dynamic>>()
        .map(AiTaskItem.fromJson)
        .toList(),
    questions: (json['questions'] is List ? json['questions'] as List : const [])
        .whereType<Map<String, dynamic>>()
        .map(AiInteractionQuestion.fromJson)
        .toList(),
  );
}

/// 待确认的写操作（SSE `pending` / `POST /ai/agent/pending`）。
class AiPendingOp {
  const AiPendingOp({
    required this.proposalId,
    this.op = '',
    this.params = const {},
    this.lastError = '',
  });

  final String proposalId;
  final String op;
  final Map<String, dynamic> params;
  final String lastError;

  String get label => op == 'draw' ? 'AI 画图' : op;

  String get paramsText {
    final prompt = params['prompt']?.toString();
    if (prompt != null && prompt.isNotEmpty) return prompt;
    return params.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
  }

  factory AiPendingOp.fromJson(Map<String, dynamic> json) => AiPendingOp(
    proposalId: (json['proposalId'] ?? '').toString(),
    op: (json['op'] ?? '').toString(),
    params: json['params'] is Map<String, dynamic>
        ? json['params'] as Map<String, dynamic>
        : const {},
    lastError: (json['lastError'] ?? '').toString(),
  );
}
