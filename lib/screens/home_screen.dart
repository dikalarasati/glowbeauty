import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/state_views.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Product>> _futureProducts;
  String _query = '';
  String _selectedType = 'Semua';

  @override
  void initState() {
    super.initState();
    _futureProducts = _service.fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _futureProducts = _service.fetchProducts();
    });
  }

  List<Product> _applyFilter(List<Product> all) {
    final q = _query.trim().toLowerCase();
    return all.where((p) {
      final matchType = _selectedType == 'Semua' || p.typeLabel == _selectedType;
      final matchQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.typeLabel.toLowerCase().contains(q) ||
          (p.category ?? '').toLowerCase().contains(q);
      return matchType && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlowBeauty ✨'),
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          // 1. LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          // 2. ERROR
          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          // 3. SUCCESS
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return ErrorView(
              message: 'Belum ada produk yang tersedia.',
              onRetry: _reload,
            );
          }
          return _buildContent(products);
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari lipstik, mascara, foundation...',
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.soft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildContent(List<Product> products) {
    final types = <String>{
      for (final p in products)
        if (p.typeLabel.isNotEmpty) p.typeLabel,
    }.toList()
      ..sort();
    final filtered = _applyFilter(products);

    return Column(
      children: [
        // Filter kategori
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final t in ['Semua', ...types])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: _selectedType == t,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      color: _selectedType == t ? Colors.white : AppColors.text,
                    ),
                    onSelected: (_) => setState(() => _selectedType = t),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${filtered.length} produk ditemukan',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? EmptyView(query: _query.isEmpty ? _selectedType : _query)
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => _reload(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final product = filtered[i];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(product: product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
