import 'package:flutter/material.dart';

import '../l10n/app_localizations_text.dart';
import '../models/task_item.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.api,
    required this.token,
    required this.onLoginRequested,
    required this.onOpenLink,
  });

  final ChengeApi api;
  final String? token;
  final VoidCallback onLoginRequested;
  final ValueChanged<String> onOpenLink;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _tasks = <TaskItem>[];
  final _busyCodes = <String>{};
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant TasksPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final tasks = await widget.api.tasks(token: widget.token);
      if (!mounted) return;
      setState(() {
        _tasks
          ..clear()
          ..addAll(tasks);
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _claim(TaskItem task) async {
    final token = widget.token;
    if (token == null) {
      widget.onLoginRequested();
      return;
    }
    if (!_busyCodes.add(task.code)) return;
    setState(() {});
    try {
      final reward = await widget.api.claimTask(task.code, token);
      if (!mounted) return;
      final coins =
          reward['coins'] is num
              ? (reward['coins'] as num).toDouble()
              : task.rewardCoins;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.rewardClaimed(coins.toString()) ??
                '奖励已领取，+$coins CC',
          ),
        ),
      );
      await _load();
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: AppTheme.coral,
          ),
        );
        await _load();
      }
    } finally {
      _busyCodes.remove(task.code);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        AppLocalizations.of(context).text('任务中心'),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context).text('刷新任务'),
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh_rounded),
        ),
        const SizedBox(width: 6),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child:
            _loading && _tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty && _tasks.isEmpty
                ? _emptyError()
                : RefreshIndicator(onRefresh: _load, child: _taskList()),
      ),
    ),
  );

  Widget _taskList() {
    final pending = _tasks.where((task) => !task.rewarded).toList();
    final completed = _tasks.where((task) => task.rewarded).toList();
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      children: [
        _summary(pending.length, completed.length),
        const SizedBox(height: 20),
        _sectionHeader('进行中', pending.length),
        if (pending.isEmpty)
          _emptySection('当前没有进行中的任务')
        else
          ...pending.map(_taskCard),
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 22),
          _sectionHeader('已完成', completed.length),
          ...completed.map(_taskCard),
        ],
        const SizedBox(height: 12),
        Center(
          child: Text(
            '奖励需要手动领取 · 任务按周期刷新',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summary(int pending, int completed) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.task_alt_rounded,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今日目标',
                style: TextStyle(
                  fontSize: 19,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '完成社区任务，领取 ChengeCoin',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$pending',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '待完成 · $completed 已完成',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _sectionHeader(String title, int count) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );

  Widget _taskCard(TaskItem task) {
    final isBusy = _busyCodes.contains(task.code);
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      task.rewarded
                          ? const Color(0xFFE0F0E8)
                          : const Color(0xFFFFE8C5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  task.type == 'checkin'
                      ? Icons.event_available_rounded
                      : Icons.flag_outlined,
                  color: task.rewarded ? AppTheme.leaf : AppTheme.ink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (task.claimable && !task.rewarded)
                          _badge('可领取', AppTheme.coral),
                        if (task.rewarded) _badge('已完成', AppTheme.leaf),
                      ],
                    ),
                    if (task.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF70817D),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (!task.rewarded) ...[
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: task.progressRatio,
                                minHeight: 6,
                                backgroundColor: const Color(0xFFE8EFEB),
                                color: AppTheme.leaf,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${task.progress}/${task.target}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF70817D),
                            ),
                          ),
                        ],
                      ),
                      if (task.type == 'checkin' && task.streak > 0) ...[
                        const SizedBox(height: 5),
                        Text(
                          '已连续签到 ${task.streak} 天 · 累计 ${task.totalDays} 天',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF70817D),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${task.rewardCoins.toStringAsFixed(task.rewardCoins % 1 == 0 ? 0 : 2)} CC',
                    style: const TextStyle(
                      color: AppTheme.coral,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (!task.rewarded)
                    SizedBox(
                      height: 36,
                      child:
                          task.claimable
                              ? FilledButton.tonal(
                                onPressed: isBusy ? null : () => _claim(task),
                                child:
                                    isBusy
                                        ? const SizedBox.square(
                                          dimension: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          task.type == 'checkin' ? '签到' : '领取',
                                        ),
                              )
                              : OutlinedButton(
                                onPressed:
                                    task.link?.isNotEmpty == true
                                        ? () => widget.onOpenLink(task.link!)
                                        : null,
                                child: Text(
                                  AppLocalizations.of(context).text('去完成'),
                                ),
                              ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) => Container(
    margin: const EdgeInsets.only(left: 7),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
    ),
  );

  Widget _emptySection(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 28),
    child: Center(
      child: Text(text, style: const TextStyle(color: Color(0xFF70817D))),
    ),
  );

  Widget _emptyError() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off_rounded, size: 44, color: AppTheme.coral),
        const SizedBox(height: 10),
        Text(_error, textAlign: TextAlign.center),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(AppLocalizations.of(context).text('重试')),
        ),
      ],
    ),
  );
}
