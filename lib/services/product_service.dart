import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Service untuk mengambil data produk dari Makeup API.
class ProductService {
  static const String _url =
      'https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline';

  /// HTTP GET -> cek status -> decode JSON -> List<Product>.
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Server merespons dengan status ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw const FormatException('Format data dari server tidak sesuai.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringanmu ya.');
    } on TimeoutException {
      throw Exception('Server terlalu lama merespons. Coba lagi nanti.');
    } on FormatException {
      throw Exception('Data dari server tidak dapat diproses.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server.');
    }
  }
}
