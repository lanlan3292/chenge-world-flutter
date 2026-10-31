import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/system_guide.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import 'ai_agent_page.dart';
import 'chenge_core_page.dart';
import 'shop_page.dart';

/// 帮助中心：后端 `system_guides` 教程列表 + 详情。
class HelpPage extends StatefulWidget {
  const HelpPage({
    super.key,
    required this.api,
    required this.token,
    this.userId,
    this.onLoginRequested,
  });

  final ChengeApi api;
  final String? token;
  final int? userId;
  final VoidCallback? onLoginRequested;

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _searchController = TextEditingController();
  final _guides = <SystemGuideSummary>[];
  final _modules = <String>[];
  String _module = '';
  String _error = '';
  bool _loading = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ticket = ++_generation;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final results = await Future.wait([
        widget.api.systemGuides(
          q: _searchController.text,
          module: _module,
          token: widget.token,
        ),
        widget.api.systemGuides(token: widget.token),
      ]);
      if (!mounted || ticket != _generation) return;
      setState(() {
        _guides
          ..clear()
          ..addAll(results[0]);
        final modules = <String>{for (final guide in results[1]) guide.module}
          ..removeWhere((item) => item.trim().isEmpty);
        _modules
          ..clear()
          ..addAll(modules.toList()..sort());
        _error = '';
      });
    } on ApiException catch (error) {
      if (!mounted || ticket != _generation) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted && ticket == _generation) setState(() => _loading = false);
    }
  }

  Future<void> _openGuide(String guideKey, {int? revision}) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => HelpGuidePage(
              api: widget.api,
              token: widget.token,
              userId: widget.userId,
              guideKey: guideKey,
              revision: revision,
              onLoginRequested: widget.onLoginRequested,
            ),
      ),
    );
  }

  List<String> _relatedChips() => _modules;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpCenter, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              l10n.helpSubtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF70817D)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: l10n.searchGuides,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.clear,
                        onPressed: () {
                          _searchController.clear();
                          _load();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
              ),
            ),
            if (_modules.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _moduleChip(l10n.allModules, ''),
                    for (final module in _relatedChips())
                      _moduleChip(module, module),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (_loading && _guides.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error.isNotEmpty)
              _errorCard(_error)
            else if (_guides.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 42, color: Color(0xFF70817D)),
                    const SizedBox(height: 10),
                    Text(l10n.noGuides, style: const TextStyle(color: Color(0xFF70817D))),
                  ],
                ),
              )
            else
              for (final guide in _guides) ...[
                _guideCard(guide),
                const SizedBox(height: 10),
              ],
            if (_loading && _guides.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _moduleChip(String label, String value) {
    final selected = _module == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) {
          if (_module == value) return;
          setState(() => _module = value);
          _load();
        },
      ),
    );
  }

  Widget _errorCard(String message) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1EE),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: const TextStyle(color: AppTheme.coral)),
        const SizedBox(height: 8),
        TextButton(onPressed: _load, child: Text(AppLocalizations.of(context).retry)),
      ],
    ),
  );

  Widget _guideCard(SystemGuideSummary guide) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openGuide(guide.guideKey, revision: guide.revision),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      guide.module,
                      if (guide.revision > 0)
                        AppLocalizations.of(context).guideRevision(guide.revision),
                    ].where((item) => item.isNotEmpty).join(' · '),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF70817D)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              guide.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            if (guide.summary.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                guide.summary,
                style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF3F514B)),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// 单篇教程详情。
class HelpGuidePage extends StatefulWidget {
  const HelpGuidePage({
    super.key,
    required this.api,
    required this.token,
    required this.guideKey,
    this.revision,
    this.userId,
    this.onLoginRequested,
  });

  final ChengeApi api;
  final String? token;
  final String guideKey;
  final int? revision;
  final int? userId;
  final VoidCallback? onLoginRequested;

  @override
  State<HelpGuidePage> createState() => _HelpGuidePageState();
}

class _HelpGuidePageState extends State<HelpGuidePage> {
  SystemGuide? _guide;
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final guide = await widget.api.systemGuide(
        widget.guideKey,
        revision: widget.revision,
        token: widget.token,
      );
      if (!mounted) return;
      setState(() => _guide = guide);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message.isEmpty
          ? AppLocalizations.of(context).guideUnavailable
          : error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openRelated(String guideKey) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => HelpGuidePage(
              api: widget.api,
              token: widget.token,
              userId: widget.userId,
              guideKey: guideKey,
              onLoginRequested: widget.onLoginRequested,
            ),
      ),
    );
  }

  void _handleAction(SystemGuideStep step) {
    final target = step.actionTarget;
    if (target == null) return;
    final token = widget.token;
    switch (target) {
      case 'account.login':
        widget.onLoginRequested?.call();
        return;
      case 'help.home':
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      case 'chengecore.home':
        if (token == null) {
          _needLogin();
          return;
        }
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ChengeCorePage(baseUrl: widget.api.baseUrl, token: token),
          ),
        );
        return;
      case 'ai.chat':
        if (token == null) {
          _needLogin();
          return;
        }
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder:
                (_) => AiAgentPage(
                  api: widget.api,
                  token: token,
                  onLoginRequested: widget.onLoginRequested ?? () {},
                ),
          ),
        );
        return;
      case 'shop.home':
      case 'shop.sell':
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder:
                (_) => ShopPage(
                  api: widget.api,
                  token: token,
                  userId: widget.userId,
                  onLoginRequested: widget.onLoginRequested ?? () {},
                ),
          ),
        );
        return;
      default:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).guideActionUnavailable(
                  step.actionLabel ?? target,
                ),
              ),
            ),
          );
    }
  }

  void _needLogin() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).goSignIn)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final guide = _guide;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          guide?.title ?? l10n.helpCenter,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading && guide == null
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty && guide == null
          ? ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_error, style: const TextStyle(color: AppTheme.coral)),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _load, child: Text(l10n.retry)),
                    ],
                  ),
                ),
              ],
            )
          : guide == null
          ? const SizedBox.shrink()
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  Text(
                    [
                      l10n.officialGuide,
                      guide.module,
                      if (guide.revision > 0) l10n.guideRevision(guide.revision),
                    ].where((item) => item.isNotEmpty).join(' · '),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    guide.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  if (guide.summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      guide.summary,
                      style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF3F514B)),
                    ),
                  ],
                  if (guide.appliesTo.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.guideAppliesTo}: ${guide.appliesTo.join(', ')}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
                    ),
                  ],
                  if (guide.requirements.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _sectionTitle(l10n.guideBeforeStart),
                    for (final item in guide.requirements)
                      _bullet(
                        Text(item, style: const TextStyle(fontSize: 13, height: 1.5)),
                      ),
                  ],
                  if (guide.steps.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _sectionTitle(l10n.guideSteps),
                    for (var i = 0; i < guide.steps.length; i++)
                      _stepCard(guide.steps[i], i + 1),
                  ],
                  if (guide.troubleshooting.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _sectionTitle(l10n.guideTroubleshooting),
                    for (final item in guide.troubleshooting) _troubleCard(item),
                  ],
                  if (guide.relatedGuides.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _sectionTitle(l10n.guideRelated),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final key in guide.relatedGuides)
                          ActionChip(
                            label: Text(key),
                            onPressed: () => _openRelated(key),
                          ),
                      ],
                    ),
                  ],
                  if (guide.revision > 0) ...[
                    const SizedBox(height: 22),
                    Text(
                      l10n.guideStableLink(guide.guideKey, guide.revision),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9AA8A3)),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
  );

  Widget _bullet(Widget child) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('· ', style: TextStyle(fontWeight: FontWeight.w800)),
        Expanded(child: child),
      ],
    ),
  );

  Widget _stepCard(SystemGuideStep step, int index) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.leaf,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$index',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                step.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        if (step.description.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            step.description,
            style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF3F514B)),
          ),
        ],
        if (step.actionTarget != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _handleAction(step),
            icon: const Icon(Icons.arrow_outward_rounded, size: 16),
            label: Text(step.actionLabel ?? step.actionTarget!),
          ),
        ],
      ],
    ),
  );

  Widget _troubleCard(SystemGuideTroubleshooting item) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2EAE5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.symptom, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        for (final check in item.checks)
          _bullet(
            Text(
              '${AppLocalizations.of(context).guideCheck}: $check',
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
          ),
        for (final line in item.resolution)
          _bullet(Text(line, style: const TextStyle(fontSize: 13, height: 1.45))),
      ],
    ),
  );
}
