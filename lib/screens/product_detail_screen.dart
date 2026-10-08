import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'detail_studio_toko.dart';
import 'hubungi_kontak.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Detail Produk',
          style: AppText.sans(size: 20, weight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductHero(product: product),
            const SizedBox(height: 20),
            _ProductSummary(product: product),
            const SizedBox(height: 10),
            Text(
              product.name == 'Mug Dinoyo'
                  ? 'Dibuat dengan teknik handmade oleh pengrajin lokal Dinoyo.'
                  : 'Dibuat dengan teliti oleh pengrajin lokal Dinoyo.',
              style: AppText.sans(
                size: 17,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                product.description,
                style: AppText.sans(
                  size: 15,
                  color: AppColors.brown,
                  height: 1.65,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _sectionTitle('Detail', trailing: 'SPESIFIKASI FISIK'),
            const SizedBox(height: 12),
            _SpecificationGrid(product: product),
            const SizedBox(height: 28),
            _sectionTitle(
              'Dibuat oleh',
              trailing: 'Mitra Terverifikasi',
              trailingColor: AppColors.sageDark,
              verified: true,
            ),
            const SizedBox(height: 12),
            _ArtisanCard(product: product),
            const SizedBox(height: 26),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.handshake_outlined,
                    size: 17,
                    color: AppColors.brown,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'KAMPUNG KERAMIK DINOYO  •  WARISAN KRIYA',
                    style: AppText.sans(
                      size: 10,
                      weight: FontWeight.w800,
                      color: AppColors.brown,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PurchaseBar(product: product),
    );
  }

  Widget _sectionTitle(
    String title, {
    required String trailing,
    Color trailingColor = AppColors.brown,
    bool verified = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: AppText.sans(size: 21, weight: FontWeight.w700)),
        ),
        if (verified) ...[
          const Icon(Icons.verified_outlined,
              size: 16, color: AppColors.sageDark),
          const SizedBox(width: 4),
        ],
        Text(
          trailing,
          style: AppText.sans(
            size: 11,
            weight: FontWeight.w800,
            color: trailingColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ProductHero extends StatelessWidget {
  final Product product;

  const _ProductHero({required this.product});

  @override
  Widget build(BuildContext context) {
    final fallback = switch (product.name) {
      'Mug Dinoyo' => (const Color(0xFFE9D4C0), Icons.local_cafe_outlined),
      'Vas Meja' => (const Color(0xFFE7E1D7), Icons.yard_outlined),
      'Piring Saji' => (const Color(0xFFE8DCC9), Icons.dinner_dining_outlined),
      _ => (const Color(0xFFE5DDCF), Icons.spa_outlined),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetPic(
              product.image,
              fallbackColor: fallback.$1,
              fallbackIcon: fallback.$2,
              fallbackIconSize: 80,
              fallbackIconColor: AppColors.brown.withValues(alpha: 0.55),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      product.limitedBatch
                          ? Icons.local_fire_department
                          : Icons.storefront_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      product.limitedBatch ? 'BATCH TERBATAS' : 'KARYA LOKAL',
                      style: AppText.sans(size: 11, weight: FontWeight.w800),
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
}

class _ProductSummary extends StatelessWidget {
  final Product product;

  const _ProductSummary({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 19, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          product.rating.toStringAsFixed(1),
          style: AppText.sans(size: 16, weight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: AppColors.peach,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${product.ratingCount} apresiasi',
          style: AppText.sans(size: 14, color: AppColors.brown),
        ),
        const Spacer(),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.sage,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Handmade Dinoyo',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(
                size: 10,
                weight: FontWeight.w800,
                color: AppColors.sageDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecificationGrid extends StatelessWidget {
  final Product product;

  const _SpecificationGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    final specs = [
      (Icons.landscape_outlined, 'MATERIAL', product.material),
      (Icons.local_cafe_outlined, 'KAPASITAS', product.capacity),
      (Icons.brush_outlined, 'FINISHING', product.finishing),
      (Icons.tune_outlined, 'KARAKTER', product.character),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: specs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 128,
      ),
      itemBuilder: (context, index) {
        final spec = specs[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(spec.$1, size: 18, color: AppColors.primary),
              ),
              const Spacer(),
              Text(
                spec.$2,
                style: AppText.sans(
                  size: 10,
                  weight: FontWeight.w800,
                  color: AppColors.brown,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                spec.$3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 15, weight: FontWeight.w700),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArtisanCard extends StatelessWidget {
  final Product product;

  const _ArtisanCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetailStudioTokoScreen(
              artisanName: product.shopName,
              selectedProduct: product,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 70,
                      height: 70,
                      color: const Color(0xFFE8D8CA),
                      child: const Icon(
                        Icons.person_outline,
                        size: 38,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppText.sans(size: 17, weight: FontWeight.w800),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 15, color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: AppText.sans(
                                size: 12,
                                weight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 9),
                            const Icon(
                              Icons.place_outlined,
                              size: 14,
                              color: AppColors.brown,
                            ),
                            Expanded(
                              child: Text(
                                'Dinoyo, Malang',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                    size: 12, color: AppColors.brown),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Mendedikasikan karya keramik khas Dinoyo dengan teknik tradisional.',
                style: AppText.sans(
                    size: 13, color: AppColors.brown, height: 1.45),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Lihat Pengrajin',
                    style: AppText.sans(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward,
                      size: 17, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _PurchaseBar extends StatelessWidget {
  final Product product;

  const _PurchaseBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KARYA ASLI DINOYO',
                    style: AppText.sans(
                      size: 10,
                      weight: FontWeight.w800,
                      color: AppColors.brown,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatRupiah(product.price),
                      style: AppText.sans(size: 25, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ArtisanContactScreen(product: product),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.chat_outlined, size: 19),
                  label: Text(
                    'Hubungi Pengrajin',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      size: 13,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
