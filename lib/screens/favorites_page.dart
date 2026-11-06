import 'package:flutter/material.dart';

import '../services/chenge_api.dart';

/// 服务端收藏列表。聊天收藏可从这里回看内容。
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, required this.api, required this.token});

  final ChengeApi api;
  final String token;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  static const _labels = <String, String>{
    'cchat': '聊天',
    'cpost': '帖子',
    'cshop': '商品',
    'cintelligence': 'AI 回复',
  };

  List<Map<String, dynamic>> _rows = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.api.favorites(widget.token);
      if (!mounted) return;
      setState(() {
        _rows = page.records;
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _loading = false;
      });
    }
  }

  Future<void> _remove(Map<String, dynamic> row) async {
    try {
      await widget.api.setFavorite(
        widget.token,
        business: '${row['business'] ?? ''}',
        targetType: '${row['targetType'] ?? ''}',
        targetId: '${row['targetId'] ?? ''}',
        contextId: '${row['contextId'] ?? ''}',
        active: false,
      );
      await _load();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏', style: TextStyle(fontWeight: FontWeight.w800))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _rows.isEmpty
                      ? ListView(children: const [SizedBox(height: 120), Center(child: Text('还没有收藏'))])
                      : ListView.separated(
                          itemCount: _rows.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final row = _rows[index];
                            final business = '${row['business'] ?? ''}';
                            final content = '${row['content'] ?? ''}'.replaceAll(RegExp(r'\s+'), ' ').trim();
                            return ListTile(
                              leading: const Icon(Icons.star_rounded),
                              title: Text(
                                '${row['title'] ?? _labels[business] ?? business}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${_labels[business] ?? business}${content.isEmpty ? '' : ' · $content'}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                tooltip: '取消收藏',
                                onPressed: () => _remove(row),
                                icon: const Icon(Icons.star_outline_rounded),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
