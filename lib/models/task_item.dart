class TaskItem {
  const TaskItem({
    required this.code,
    required this.name,
    required this.type,
    required this.progress,
    required this.target,
    required this.rewardCoins,
    required this.claimable,
    required this.rewarded,
    this.description,
    this.link,
    this.periodType,
    this.streak = 0,
    this.totalDays = 0,
  });

  final String code;
  final String name;
  final String type;
  final int progress;
  final int target;
  final double rewardCoins;
  final bool claimable;
  final bool rewarded;
  final String? description;
  final String? link;
  final String? periodType;
  final int streak;
  final int totalDays;

  double get progressRatio => target <= 0 ? 0 : (progress / target).clamp(0, 1).toDouble();

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        code: _text(json['code']),
        name: _text(json['name'], fallback: '每日任务'),
        type: _text(json['type'], fallback: 'action'),
        progress: _integer(json['progress']),
        target: _integer(json['target'], fallback: 1),
        rewardCoins: _number(json['rewardCoins']),
        claimable: json['claimable'] == true,
        rewarded: json['rewarded'] == true,
        description: _nullableText(json['description']),
        link: _nullableText(json['link']),
        periodType: _nullableText(json['periodType']),
        streak: _integer(json['streak']),
        totalDays: _integer(json['totalDays']),
      );

  static int _integer(Object? value, {int fallback = 0}) => value is num ? value.toInt() : int.tryParse('$value') ?? fallback;
  static double _number(Object? value) => value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }
}