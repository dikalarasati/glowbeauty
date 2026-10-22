import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gambar jaringan dengan loading dan fallback jika gagal dimuat.
class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    Widget placeholder(IconData icon) => Container(
          width: width,
          height: height,
          color: AppColors.soft,
          child: Icon(icon, color: AppColors.primary.withAlpha(140)),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? placeholder(Icons.image_not_supported_outlined)
          : Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Image.network(
                url,
                fit: fit,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return placeholder(Icons.auto_awesome_rounded);
                },
                errorBuilder: (_, __, ___) =>
                    placeholder(Icons.broken_image_outlined),
              ),
            ),
    );
  }
}
