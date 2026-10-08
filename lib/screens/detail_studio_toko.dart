import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'hubungi_kontak.dart';
import 'product_detail_screen.dart';

class DetailStudioTokoScreen extends StatelessWidget {
  final String artisanName;
  final Product? selectedProduct;

  const DetailStudioTokoScreen({
    super.key,
    required this.artisanName,
    this.selectedProduct,
  });

  String get _displayName => switch (artisanName) {
        'Studio Pak Slamet' => 'Studio Pak Slamet Riyadi',
        _ => artisanName,
      };

  bool get _isPakSlametStudio => artisanName == 'Studio Pak Slamet';

  List<Product> get _studioProducts =>
      products.where((product) => product.shopName == artisanName).toList();

  double get _rating {
    if (_studioProducts.isEmpty) return selectedProduct?.rating ?? 0;
    final totalReviews = _studioProducts.fold<int>(
      0,
      (total, product) => total + product.ratingCount,
    );
    if (totalReviews == 0) return _studioProducts.first.rating;
    final weightedRating = _studioProducts.fold<double>(
      0,
      (total, product) => total + product.rating * product.ratingCount,
    );
    return weightedRating / totalReviews;
  }

  int get _reviewCount => _studioProducts.fold<int>(
      0, (total, product) => total + product.ratingCount);

  Product? get _contactProduct =>
      selectedProduct ??
      (_studioProducts.isNotEmpty ? _studioProducts.first : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Detail Studio Toko',
          style: AppText.sans(size: 19, weight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        ),
        actions: [
          IconButton(
            tooltip: 'Salin info studio',
            onPressed: () => _copyStudioInfo(context),
            icon: const Icon(Icons.share_outlined, color: AppColors.ink),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudioHero(context),
            const SizedBox(height: 22),
            _buildAbout(),
            const SizedBox(height: 26),
            _buildProducts(context),
            const SizedBox(height: 22),
            _buildWorkshop(context),
            const SizedBox(height: 22),
            _buildReviews(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioHero(BuildContext context) {
    final contactProduct = _contactProduct;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 270,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AssetPic(
                  'assets/images/pengrajin.jpg',
                  fallbackColor: Color(0xFFE8D8CA),
                  fallbackIcon: Icons.storefront_outlined,
                  fallbackIconSize: 76,
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isPakSlametStudio
                              ? 'MAESTRO DINOYO'
                              : 'PENGRAJIN DINOYO',
                          style:
                              AppText.sans(size: 10, weight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (_isPakSlametStudio)
                      const _InfoPill(
                        label: 'Generasi ke-2',
                        color: AppColors.sage,
                        foreground: AppColors.sageDark,
                        icon: Icons.history_edu_outlined,
                      )
                    else
                      const _InfoPill(
                        label: 'Koleksi Lokal',
                        color: AppColors.sage,
                        foreground: AppColors.sageDark,
                      ),
                    _InfoPill(
                      label: _isPakSlametStudio ? 'Est. 1984' : 'Sentra Dinoyo',
                      color: const Color(0xFFEFE7DF),
                      foreground: AppColors.brown,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _displayName,
                  style: AppText.sans(size: 21, weight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 14,
                  runSpacing: 7,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _MetaItem(
                      icon: Icons.star,
                      iconColor: AppColors.primary,
                      text:
                          '${_rating.toStringAsFixed(1)} ($_reviewCount ulasan)',
                    ),
                    const _MetaItem(
                      icon: Icons.place_outlined,
                      text: 'Dinoyo, Malang',
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                const _MetaItem(
                  icon: Icons.access_time,
                  text: '08.00–17.00 WIB',
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _HeroButton(
                        label: 'Hubungi',
                        icon: Icons.message_outlined,
                        primary: true,
                        onTap: contactProduct == null
                            ? () =>
                                _showUnavailable(context, 'Kontak pengrajin')
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ArtisanContactScreen(
                                      product: contactProduct,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _HeroButton(
                        label: 'Peta Studio',
                        icon: Icons.explore_outlined,
                        onTap: () => _openMap(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
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
              const SizedBox(width: 8),
              Text(
                'Tentang Pengrajin',
                style: AppText.sans(size: 18, weight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isPakSlametStudio
                ? '$_displayName adalah pengrajin lokal Dinoyo yang menghasilkan '
                    'karya keramik handmade. Studio ini melestarikan teknik putar '
                    'tradisional dengan tanah liat lokal dan pembakaran tungku.'
                : '$_displayName adalah toko keramik di sentra Dinoyo. Jelajahi '
                    'koleksi karya yang tersedia dan hubungi pengrajin untuk '
                    'menanyakan informasi lebih lanjut.',
            style: AppText.sans(
              size: 14,
              color: AppColors.brown,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 10),
          if (_isPakSlametStudio)
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  label: 'Tungku Kayu 1200°C',
                  color: Color(0xFFECE8E3),
                  foreground: AppColors.ink,
                  icon: Icons.local_fire_department_outlined,
                ),
                _InfoPill(
                  label: 'Kaolin Alami Dinoyo',
                  color: Color(0xFFECE8E3),
                  foreground: AppColors.ink,
                  icon: Icons.eco_outlined,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProducts(BuildContext context) {
    final studioProducts = _studioProducts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karya Studio',
                    style: AppText.sans(size: 19, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Koleksi keramik pilihan langsung dari studio.',
                    style: AppText.sans(size: 12, color: AppColors.brown),
                  ),
                ],
              ),
            ),
            Text(
              '${studioProducts.length} Koleksi',
              style: AppText.sans(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (studioProducts.isEmpty)
          _emptyCollection()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: studioProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 224,
            ),
            itemBuilder: (context, index) => _StudioProductCard(
              product: studioProducts[index],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ProductDetailScreen(product: studioProducts[index]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyCollection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'Koleksi studio belum tersedia.',
        textAlign: TextAlign.center,
        style: AppText.sans(size: 13, color: AppColors.brown),
      ),
    );
  }

  Widget _buildWorkshop(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, size: 17, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                'WORKSHOP LANGSUNG',
                style: AppText.sans(
                  size: 10,
                  weight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Workshop Studio',
            style: AppText.sans(
              size: 19,
              weight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belajar membuat keramik langsung bersama pengrajin studio.',
            style: AppText.sans(size: 14, color: Colors.white, height: 1.45),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => _showUnavailable(context, 'Informasi workshop'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: const StadiumBorder(),
            ),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: Text(
              'Lihat Workshop',
              style: AppText.sans(
                size: 13,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ulasan Pengunjung',
                style: AppText.sans(size: 18, weight: FontWeight.w800),
              ),
            ),
            const Icon(Icons.star, size: 18, color: AppColors.primary),
            const SizedBox(width: 3),
            Text(
              _rating.toStringAsFixed(1),
              style: AppText.sans(size: 17, weight: FontWeight.w800),
            ),
            Text('/5', style: AppText.sans(size: 12, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_outlined, color: AppColors.sageDark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Rating dirangkum dari $_reviewCount ulasan pada koleksi studio.',
                  style: AppText.sans(
                    size: 13,
                    color: AppColors.brown,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _copyStudioInfo(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text: '$_displayName - Kampung Keramik Dinoyo, Malang',
      ),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Info studio berhasil disalin.')),
      );
  }

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': 'Kampung Keramik Dinoyo Malang',
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || opened) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka peta studio.')),
      );
  }

  void _showUnavailable(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature belum tersedia saat ini.')),
      );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color foreground;
  final IconData? icon;

  const _InfoPill({
    required this.label,
    required this.color,
    required this.foreground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppText.sans(
              size: 10,
              weight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _MetaItem({
    required this.icon,
    required this.text,
    this.iconColor = AppColors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 4),
        Text(text, style: AppText.sans(size: 12, color: AppColors.brown)),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _HeroButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              primary ? AppColors.primary : const Color(0xFFE9E5E0),
          foregroundColor: primary ? Colors.white : AppColors.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: const StadiumBorder(),
        ),
        icon: Icon(icon,
            size: 17, color: primary ? Colors.white : AppColors.primary),
        label: Text(
          label,
          style: AppText.sans(
            size: 13,
            weight: FontWeight.w700,
            color: primary ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _StudioProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _StudioProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(18),
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
                  AssetPic(
                    product.image,
                    fallbackColor: const Color(0xFFE9D4C0),
                    fallbackIcon: Icons.local_cafe_outlined,
                    fallbackIconSize: 42,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        product.category,
                        style: AppText.sans(
                          size: 9,
                          weight: FontWeight.w700,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppText.sans(size: 13, weight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.star,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: AppText.sans(size: 10, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatRupiah(product.price),
                    style: AppText.sans(
                      size: 15,
                      weight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
