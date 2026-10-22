import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glowbeauty/models/product.dart';
import 'package:glowbeauty/widgets/rating_badge.dart';

void main() {
  group('Product.fromJson', () {
    test('mem-parsing data lengkap dengan benar', () {
      final p = Product.fromJson({
        'id': 439,
        'brand': 'maybelline',
        'name': 'Maybelline Fit Me Blush',
        'price': '10.29',
        'image_link': 'http://example.com/a.png',
        'description': 'Line 1\n\n\t  Line 2',
        'rating': 4.8,
        'category': 'powder',
        'product_type': 'lip_liner',
        'product_link': 'https://well.ca/x',
        'product_colors': [
          {'hex_value': '#FB8684', 'colour_name': 'Deep Coral  '},
        ],
      });

      expect(p.id, 439);
      expect(p.brand, 'Maybelline');
      expect(p.priceLabel, '\$10.29');
      expect(p.imageUrl, 'https://example.com/a.png');
      expect(p.description, 'Line 1 Line 2');
      expect(p.typeLabel, 'Lip Liner');
      expect(p.subtitle, 'Maybelline  •  Lip Liner');
      expect(p.colors.single.name, 'Deep Coral');
    });

    test('menangani field null dengan aman', () {
      final p = Product.fromJson({
        'id': 1,
        'brand': 'maybelline',
        'name': 'Produk Tanpa Data',
        'price': null,
        'rating': null,
        'category': null,
        'product_type': 'mascara',
        'product_colors': [],
      });

      expect(p.priceLabel, 'N/A');
      expect(p.rating, isNull);
      expect(p.category, isNull);
      expect(p.colors, isEmpty);
    });
  });

  testWidgets('RatingBadge menampilkan nilai rating', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RatingBadge(rating: 4.5))),
    );
    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('RatingBadge menampilkan "-" jika rating null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RatingBadge(rating: null))),
    );
    expect(find.text('-'), findsOneWidget);
  });
}
