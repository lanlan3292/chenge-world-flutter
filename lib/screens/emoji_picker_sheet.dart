import 'package:flutter/material.dart';

import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class EmojiPickerSheet extends StatefulWidget {
  const EmojiPickerSheet({required this.api, required this.token});

  final ChengeApi api;
  final String token;

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet> {
  final _assets = <EmojiAsset>[];
  bool _loading = true;
  String _error = '';

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
    final height = MediaQuery.sizeOf(context).height * 0.45;
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
                  const Expanded(
                    child: Text('表情包', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_error, style: const TextStyle(color: AppTheme.coral)),
              ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _assets.isEmpty
                      ? const Center(
                          child: Text('暂无表情包，可在商店购买', style: TextStyle(color: Color(0xFF70817D))),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: _assets.length,
                          itemBuilder: (context, index) {
                            final asset = _assets[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Navigator.pop(context, asset),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F8F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: asset.url?.isNotEmpty == true
                                    ? Image.network(
                                        asset.url!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Center(
                                          child: Text(
                                            asset.displayName.characters.first,
                                            style: const TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          asset.displayName,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
