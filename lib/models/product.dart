import 'package:flutter/material.dart';

/// Pilihan warna/shade sebuah produk.
class ProductColor {
  final Color color;
  final String? name;

  const ProductColor({required this.color, this.name});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      color: _hexToColor(json['hex_value'] as String?),
      name: (json['colour_name'] as String?)?.trim(),
    );
  }

  static Color _hexToColor(String? hex) {
    if (hex == null) return Colors.grey;
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 3) {
      h = h.split('').map((c) => '$c$c').join();
    }
    if (h.length != 6) return Colors.grey;
    final value = int.tryParse(h, radix: 16);
    return value == null ? Colors.grey : Color(0xFF000000 | value);
  }
}

/// Model data produk dari Makeup API.
class Product {
  final int id;
  final String brand;
  final String name;
  final double? price;
  final String imageUrl;
  final String description;
  final double? rating;
  final String? category;
  final String productType;
  final String? productLink;
  final List<ProductColor> colors;

  const Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.category,
    required this.productType,
    required this.productLink,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawColors = json['product_colors'];
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      brand: _capitalize((json['brand'] as String?) ?? '-'),
      name: ((json['name'] as String?) ?? 'Tanpa nama').trim(),
      price: _toDouble(json['price']),
      imageUrl: _normalizeUrl(
        (json['image_link'] as String?) ??
            (json['api_featured_image'] as String?) ??
            '',
      ),
      description: _cleanText((json['description'] as String?) ?? ''),
      rating: _toDouble(json['rating']),
      category: json['category'] as String?,
      productType: (json['product_type'] as String?) ?? '',
      productLink: json['product_link'] as String?,
      colors: rawColors is List
          ? rawColors
              .whereType<Map<String, dynamic>>()
              .map(ProductColor.fromJson)
              .toList()
          : const [],
    );
  }

  /// Harga dalam format "$14.99". Mengembalikan "N/A" jika harga tidak valid.
  String get priceLabel =>
      (price == null || price == 0) ? 'N/A' : '\$${price!.toStringAsFixed(2)}';

  /// Contoh: "lip_liner" -> "Lip Liner".
  String get typeLabel => productType
      .split('_')
      .where((w) => w.isNotEmpty)
      .map(_capitalize)
      .join(' ');

  /// Subtitle kartu: "Maybelline • Lip Liner".
  String get subtitle =>
      typeLabel.isEmpty ? brand : '$brand  •  $typeLabel';

  // ---------- Helper ----------

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  /// Sebagian URL dari API diawali "//", ubah menjadi https.
  static String _normalizeUrl(String url) {
    if (url.startsWith('//')) return 'https:$url';
    if (url.startsWith('http://')) return url.replaceFirst('http://', 'https://');
    return url;
  }

  /// Rapikan whitespace/tab/newline pada deskripsi dari API.
  static String _cleanText(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim();
}
