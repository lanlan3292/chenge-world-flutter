import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'image_viewer_page.dart';

/// Article-content image gallery with swipe paging (touch + mouse).
class PostImagesCarousel extends StatefulWidget {
  const PostImagesCarousel({
    super.key,
    required this.images,
    required this.resolveUrl,
  });

  final List<String> images;
  final String Function(String url) resolveUrl;

  @override
  State<PostImagesCarousel> createState() => _PostImagesCarouselState();
}

class _PostImagesCarouselState extends State<PostImagesCarousel> {
  late final PageController _controller;
  int _index = 0;

  List<String> get _resolved =>
      widget.images.map(widget.resolveUrl).where((u) => u.isNotEmpty).toList();

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void didUpdateWidget(covariant PostImagesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images) {
      _index = 0;
      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final n = _resolved.length;
    if (n <= 1) return;
    final next = (_index + delta + n) % n;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  void _openViewer(int index) {
    final urls = _resolved;
    if (urls.isEmpty) return;
    ImageViewerPage.open(
      context,
      imageUrls: urls,
      initialIndex: index.clamp(0, urls.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _resolved;
    if (images.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: scheme.surfaceContainerHighest),
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                  },
                ),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => _openViewer(i),
                      child: Image.network(
                        images[i],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: _NavButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _go(-1),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _NavButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _go(1),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Text(
                        '${_index + 1} / ${images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
