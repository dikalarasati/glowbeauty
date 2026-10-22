import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Badge rating bintang. Menampilkan "-" jika rating belum tersedia.
class RatingBadge extends StatelessWidget {
  final double? rating;
  final bool large;

  const RatingBadge({super.key, required this.rating, this.large = false});

  @override
  Widget build(BuildContext context) {
    final hasRating = rating != null;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded,
              size: large ? 20 : 15, color: AppColors.star),
          const SizedBox(width: 3),
          Text(
            hasRating ? rating!.toStringAsFixed(1) : '-',
            style: TextStyle(
              fontSize: large ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8A5A00),
            ),
          ),
        ],
      ),
    );
  }
}
