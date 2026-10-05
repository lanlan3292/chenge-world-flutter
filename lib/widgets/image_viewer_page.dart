import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Full-screen image viewer with pinch-to-zoom and horizontal paging
/// (touch swipe + mouse drag).
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final Object? heroTag;

  /// Open one or more images. [imageUrls] must be non-empty.
  static Future<void> open(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
    Object? heroTag,
  }) {
    final urls = imageUrls.map((u) => u.trim()).where((u) => u.isNotEmpty).toList();
    if (urls.isEmpty) return Future.value();
    final index = initialIndex.clamp(0, urls.length - 1);
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => ImageViewerPage(
          imageUrls: urls,
          initialIndex: index,
          heroTag: heroTag,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Convenience for a single URL (markdown / cover).
  static Future<void> openSingle(
    BuildContext context, {
    required String imageUrl,
    Object? heroTag,
  }) {
    return open(context, imageUrls: [imageUrl], heroTag: heroTag);
  }

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;
    final multi = urls.length > 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dim background — tap empty area to close (when not zoomed).
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const ColoredBox(color: Colors.transparent),
          ),
          // ScrollConfiguration enables mouse-drag paging on desktop.
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
              itemCount: urls.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final url = urls[i];
                Widget image = InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5,
                  child: Center(
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 64,
                      ),
                    ),
                  ),
                );
                if (i == widget.initialIndex && widget.heroTag != null) {
                  image = Hero(tag: widget.heroTag!, child: image);
                }
                return image;
              },
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
                if (multi)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Text(
                            '${_index + 1} / ${urls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
