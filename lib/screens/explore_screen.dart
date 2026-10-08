import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'detail_studio_toko.dart';
import 'product_detail_screen.dart';

enum _ExploreFilter { all, products, artisans }

class _Artisan {
  final String name;
  final String description;
  final double rating;
  final String badge;
  final IconData icon;
  final Color color;

  const _Artisan({
    required this.name,
    required this.description,
    required this.rating,
    required this.badge,
    required this.icon,
    required this.color,
  });
}

const _artisans = [
  _Artisan(
    name: 'Studio Pak Slamet',
    description: 'Pengrajin gerabah & stoneware bakaran tinggi.',
    rating: 4.9,
    badge: 'Bengkel aktif',
    icon: Icons.person_outline,
    color: Color(0xFFE8D8CA),
  ),
  _Artisan(
    name: 'Toko Keramik Bu Sari',
    description: 'Keramik dekoratif buatan tangan khas Dinoyo.',
    rating: 4.8,
    badge: 'Toko pilihan',
    icon: Icons.storefront_outlined,
    color: Color(0xFFDDE5D4),
  ),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final _savedProducts = <String>{};
  _ExploreFilter _filter = _ExploreFilter.all;
  bool _sortByPrice = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _query => _searchController.text.trim().toLowerCase();

  List<Product> get _visibleProducts {
    final result = products.where((product) {
      if (_query.isEmpty) return true;
      return '${product.name} ${product.category} ${product.shopName}'
          .toLowerCase()
          .contains(_query);
    }).toList();
    if (_sortByPrice) result.sort((a, b) => a.price.compareTo(b.price));
    return result;
  }

  List<_Artisan> get _visibleArtisans => _artisans.where((artisan) {
        return _query.isEmpty ||
            '${artisan.name} ${artisan.description}'
                .toLowerCase()
                .contains(_query);
      }).toList();

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Urutkan karya',
                style: AppText.sans(size: 20, weight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Rekomendasi', style: AppText.sans(size: 15)),
                trailing: !_sortByPrice
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _sortByPrice = false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Harga terendah', style: AppText.sans(size: 15)),
                trailing: _sortByPrice
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _sortByPrice = true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAiInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Cari keramik dengan AI',
          style: AppText.sans(size: 20, weight: FontWeight.w800),
        ),
        content: Text(
          'Ceritakan keramik seperti apa yang kamu cari. Rekomendasi AI akan hadir di pengembangan berikutnya.',
          style: AppText.sans(size: 15, color: AppColors.brown, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Mengerti',
              style: AppText.sans(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showProducts = _filter != _ExploreFilter.artisans;
    final showArtisans = _filter != _ExploreFilter.products;
    final visibleProducts = _visibleProducts;
    final visibleArtisans = _visibleArtisans;
    final noResults = switch (_filter) {
      _ExploreFilter.all => visibleProducts.isEmpty && visibleArtisans.isEmpty,
      _ExploreFilter.products => visibleProducts.isEmpty,
      _ExploreFilter.artisans => visibleArtisans.isEmpty,
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.fingerprint,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'SENTRA DINOYO MALANG',
                  style: AppText.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Jelajah',
                style: AppText.sans(size: 32, weight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(
              'Temukan karya dan kenali pengrajin Dinoyo.',
              style:
                  AppText.sans(size: 15, color: AppColors.brown, height: 1.45),
            ),
            const SizedBox(height: 20),
            _buildSearch(),
            const SizedBox(height: 16),
            _buildFilterChips(),
            if (showProducts &&
                (visibleProducts.isNotEmpty ||
                    _filter == _ExploreFilter.products)) ...[
              const SizedBox(height: 30),
              _buildSectionHeading(
                title: 'Karya Keramik',
                subtitle: 'Temukan karya dari tangan pengrajin lokal.',
                action: 'Lihat Semua',
                onAction: () =>
                    setState(() => _filter = _ExploreFilter.products),
              ),
              const SizedBox(height: 14),
              _buildProducts(),
            ],
            if (showArtisans &&
                (visibleArtisans.isNotEmpty ||
                    _filter == _ExploreFilter.artisans)) ...[
              const SizedBox(height: 32),
              _buildSectionHeading(
                title: 'Kenal Pengrajinnya',
                subtitle: 'Di balik setiap karya, ada tangan dan cerita.',
                action: 'Kisah',
                onAction: () =>
                    setState(() => _filter = _ExploreFilter.artisans),
              ),
              const SizedBox(height: 14),
              _buildArtisans(),
            ],
            if (noResults) ...[
              const SizedBox(height: 24),
              _buildEmptyState(),
            ],
            if (_filter == _ExploreFilter.all) ...[
              const SizedBox(height: 24),
              _buildAiCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const LogoMark(size: 32),
        ),
        const SizedBox(width: 10),
        Text('Jelajah', style: AppText.sans(size: 20, weight: FontWeight.w800)),
        const Spacer(),
        IconButton(
          tooltip: 'Notifikasi',
          onPressed: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Belum ada notifikasi baru.')),
            ),
          icon: const Icon(Icons.notifications_none, color: AppColors.brown),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      textInputAction: TextInputAction.search,
      style: AppText.sans(size: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Cari keramik, toko, atau pengrajin...',
        hintStyle: AppText.sans(size: 14, color: AppColors.muted),
        prefixIcon: const Icon(Icons.search, color: AppColors.brown),
        suffixIcon: IconButton(
          tooltip: 'Urutkan karya',
          onPressed: _showFilters,
          icon: const Icon(Icons.tune, color: AppColors.brown),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Semua',
            icon: Icons.grid_view_rounded,
            selected: _filter == _ExploreFilter.all,
            onTap: () => setState(() => _filter = _ExploreFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Karya',
            icon: Icons.spa_outlined,
            selected: _filter == _ExploreFilter.products,
            onTap: () => setState(() => _filter = _ExploreFilter.products),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pengrajin',
            icon: Icons.handyman_outlined,
            selected: _filter == _ExploreFilter.artisans,
            onTap: () => setState(() => _filter = _ExploreFilter.artisans),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.sans(size: 21, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style:
                    AppText.sans(size: 13, color: AppColors.brown, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onAction,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  action,
                  style: AppText.sans(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_forward,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProducts() {
    final visibleProducts = _visibleProducts;
    if (visibleProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 306,
      ),
      itemBuilder: (context, index) {
        final product = visibleProducts[index];
        return _ProductCard(
          product: product,
          saved: _savedProducts.contains(product.name),
          onSave: () {
            setState(() {
              if (!_savedProducts.add(product.name)) {
                _savedProducts.remove(product.name);
              }
            });
          },
          onTap: () => _showProductDetails(product),
        );
      },
    );
  }

  Widget _buildArtisans() {
    final visibleArtisans = _visibleArtisans;
    if (visibleArtisans.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 244,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: visibleArtisans.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _ArtisanCard(
          artisan: visibleArtisans[index],
          onTap: () => _showArtisanDetails(visibleArtisans[index]),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          _query.isEmpty
              ? 'Belum ada hasil untuk pilihan ini.'
              : 'Tidak ada hasil untuk “${_searchController.text.trim()}”. Coba kata kunci lain.',
          textAlign: TextAlign.center,
          style: AppText.sans(size: 14, color: AppColors.brown),
        ),
      );

  Widget _buildAiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.peach,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum tahu mau pilih apa?',
                  style: AppText.sans(size: 15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  'Cari keramik sesuai gayamu.',
                  style: AppText.sans(size: 12, color: AppColors.brown),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: _showAiInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Cari AI',
                style: AppText.sans(
                  size: 13,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _showArtisanDetails(_Artisan artisan) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailStudioTokoScreen(artisanName: artisan.name),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.field,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppColors.brown,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.sans(
                  size: 13,
                  weight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.saved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final artwork = _productArtwork(product);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AssetPic(
                    product.image,
                    fallbackColor: artwork.$1,
                    fallbackIcon: artwork.$2,
                    fallbackIconSize: 54,
                    fallbackIconColor: AppColors.brown.withValues(alpha: 0.65),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style:
                                AppText.sans(size: 11, weight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        product.category,
                        style: AppText.sans(
                          size: 10,
                          weight: FontWeight.w700,
                          color: AppColors.sageDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 9, 10, 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(size: 16, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 13, color: AppColors.brown),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppText.sans(size: 11, color: AppColors.brown),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatRupiah(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(
                              size: 14,
                              weight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        InkResponse(
                          onTap: onSave,
                          radius: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border,
                              size: 19,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, IconData) _productArtwork(Product product) {
    switch (product.name) {
      case 'Mug Dinoyo':
        return (const Color(0xFFE9D4C0), Icons.local_cafe_outlined);
      case 'Vas Meja':
        return (const Color(0xFFE7E1D7), Icons.yard_outlined);
      case 'Piring Saji':
        return (const Color(0xFFE8DCC9), Icons.dinner_dining_outlined);
      default:
        return (const Color(0xFFE5DDCF), Icons.spa_outlined);
    }
  }
}

class _ArtisanCard extends StatelessWidget {
  final _Artisan artisan;
  final VoidCallback onTap;

  const _ArtisanCard({required this.artisan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 286,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: artisan.color,
                      child:
                          Icon(artisan.icon, size: 76, color: AppColors.brown),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _RatingBadge(rating: artisan.rating),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          artisan.badge,
                          style: AppText.sans(
                            size: 10,
                            weight: FontWeight.w700,
                            color: AppColors.sageDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisan.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(size: 17, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artisan.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(
                          size: 12, color: AppColors.brown, height: 1.4),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(Icons.verified_outlined,
                            size: 15, color: AppColors.sageDark),
                        const SizedBox(width: 5),
                        Text(
                          artisan.badge,
                          style: AppText.sans(
                              size: 11,
                              weight: FontWeight.w700,
                              color: AppColors.sageDark),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right,
                            size: 17, color: AppColors.brown),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 14, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: AppText.sans(size: 11, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
