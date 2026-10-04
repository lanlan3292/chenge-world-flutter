import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class EmojiPickerSheet extends StatefulWidget {
  const EmojiPickerSheet({super.key, required this.api, required this.token});

  final ChengeApi api;
  final String token;

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet> {
  final _assets = <EmojiAsset>[];
  bool _loading = true;
  bool? _isWide;
  bool _closingForResize = false;
  int? _selectedItemId;
  String _error = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    if (_isWide == null) {
      _isWide = isWide;
    } else if (isWide != _isWide) {
      _isWide = isWide;
      _closingForResize = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

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
      final list = await widget.api.myEmojiAssets(widget.token);
      if (!mounted) return;
      setState(() {
        _assets
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.75;
    final categories = <int, String>{};
    for (final asset in _assets) {
      categories.putIfAbsent(
        asset.itemId,
        () => asset.title ?? AppLocalizations.of(context).emojiPackTitle(asset.itemId),
      );
    }
    final visibleAssets =
        _selectedItemId == null
            ? _assets
            : _assets
                .where((asset) => asset.itemId == _selectedItemId)
                .toList();
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0DBD6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).emojiPacks,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context).close,
                    onPressed: _closingForResize
                        ? null
                        : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            if (categories.length > 1)
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(AppLocalizations.of(context).all),
                        selected: _selectedItemId == null,
                        onSelected:
                            (_) => setState(() => _selectedItemId = null),
                      ),
                    ),
                    for (final entry in categories.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(entry.value),
                          selected: _selectedItemId == entry.key,
                          onSelected:
                              (_) =>
                                  setState(() => _selectedItemId = entry.key),
                        ),
                      ),
                  ],
                ),
              ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _error,
                  style: const TextStyle(color: AppTheme.coral),
                ),
              ),
            Expanded(
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : visibleAssets.isEmpty
                      ? Center(
                        child: Text(
                          AppLocalizations.of(context).noEmojiPacksBuyInShop,
                          style: const TextStyle(color: Color(0xFF70817D)),
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                        itemCount: visibleAssets.length,
                        itemBuilder: (context, index) {
                          final asset = visibleAssets[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => Navigator.pop(context, asset),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F8F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child:
                                  asset.url?.isNotEmpty == true
                                      ? Image.network(
                                        asset.url!,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (_, __, ___) => Center(
                                              child: Text(
                                                (asset.key ?? asset.displayName)
                                                    .characters
                                                    .first,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                      )
                                      : Center(
                                        child: Text(
                                          asset.key ?? asset.displayName,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
