import 'package:flutter/material.dart';

/// Full-screen image viewer with pinch-to-zoom.
class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({super.key, required this.imageUrl, this.heroTag});

  final String imageUrl;
  final Object? heroTag;

  static Future<void> open(
    BuildContext context, {
    required String imageUrl,
    Object? heroTag,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => ImageViewerPage(
          imageUrl: imageUrl,
          heroTag: heroTag,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
            color: Colors.white54,
            size: 64,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const ColoredBox(color: Colors.transparent),
          ),
          if (heroTag != null)
            Hero(tag: heroTag!, child: image)
          else
            image,
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
