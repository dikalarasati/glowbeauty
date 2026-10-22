import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_badge.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto besar
            Center(
              child: Hero(
                tag: 'product-${product.id}',
                child: ProductImage(
                  url: product.imageUrl,
                  width: double.infinity,
                  height: 280,
                  radius: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Brand & kategori
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _tag(product.brand, AppColors.primary, Colors.white),
                if (product.typeLabel.isNotEmpty)
                  _tag(product.typeLabel, AppColors.soft, AppColors.primaryDark),
                if ((product.category ?? '').isNotEmpty)
                  _tag(product.category!, const Color(0xFFF1E4FA),
                      const Color(0xFF7B4FA3)),
              ],
            ),
            const SizedBox(height: 14),

            // Nama
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),

            // Harga + rating
            Row(
              children: [
                Text(
                  product.priceLabel,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                RatingBadge(rating: product.rating, large: true),
              ],
            ),
            const SizedBox(height: 22),

            // Pilihan warna
            if (product.colors.isNotEmpty) ...[
              _sectionTitle('Pilihan Warna (${product.colors.length})'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: [
                  for (final c in product.colors) _colorDot(c),
                ],
              ),
              const SizedBox(height: 22),
            ],

            // Deskripsi
            _sectionTitle('Deskripsi'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.description.isEmpty
                    ? 'Deskripsi belum tersedia untuk produk ini.'
                    : product.description,
                style: const TextStyle(fontSize: 13.5, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      );

  Widget _tag(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      );

  Widget _colorDot(ProductColor c) {
    final label = (c.name == null || c.name!.isEmpty) ? null : c.name!;
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
