import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_data.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  /// Dipanggil untuk pindah tab di bottom navigation (0 Home, 1 Jelajah, 2 Kegiatan, 3 Profil)
  final ValueChanged<int> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  void _toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openMaps(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Kampung+Keramik+Dinoyo+Malang',
    );
    var ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && context.mounted) {
      _toast(context, 'Tidak dapat membuka Google Maps.');
    }
  }

  void _showAiInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Cari Keramik dengan AI',
          style: AppText.sans(size: 20, weight: FontWeight.w800),
        ),
        content: Text(
          'Fitur ini direncanakan untuk tahap pengembangan berikutnya. '
          'Pengguna akan menjelaskan kebutuhan dan gaya yang diinginkan, '
          'lalu sistem merekomendasikan keramik yang paling sesuai.',
          style: AppText.sans(size: 15, color: AppColors.brown, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Mengerti',
              style: AppText.sans(
                size: 15,
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
    final name = AuthService.instance.firstName;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            const SizedBox(height: 18),
            Text(
              'Halo, $name \u{1F44B}',
              style: AppText.sans(size: 28, weight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Yuk, kenal lebih dekat dengan Kampung Keramik Dinoyo.',
              style: AppText.sans(size: 15, color: AppColors.brown, height: 1.45),
            ),
            const SizedBox(height: 20),
            _buildHero(),
            const SizedBox(height: 28),
            _buildActivities(context),
            const SizedBox(height: 16),
            _buildStoryCard(context),
            const SizedBox(height: 28),
            _buildProducts(),
            const SizedBox(height: 28),
            _buildAiCard(context),
            const SizedBox(height: 16),
            _buildRatingCard(context),
            const SizedBox(height: 16),
            _buildVisitCard(context),
          ],
        ),
      ),
    );
  }

  // ---------- Bagian atas ----------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const LogoMark(size: 34),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KAMPUNG WISATA',
              style: AppText.sans(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.brown,
                letterSpacing: 0.8,
              ),
            ),
            Text('Home', style: AppText.sans(size: 22, weight: FontWeight.w800)),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Notifikasi',
          onPressed: () => _toast(context, 'Belum ada notifikasi baru.'),
          icon: const Icon(Icons.notifications_none, size: 26),
          color: AppColors.ink,
        ),
        const SizedBox(width: 4),
        Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onNavigate(3),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Banner ----------
  Widget _buildHero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AssetPic('assets/images/hero.jpg'),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33000000), Color(0xB8000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WARISAN BUDAYA MALANG',
                    style: AppText.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.peach,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dari Tanah Menjadi Cerita',
                    style: AppText.serif(
                      size: 28,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kenali karya, pengrajin, dan pengalaman keramik.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 14, color: Colors.white, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Mulai Jelajah',
                    showArrow: true,
                    expand: false,
                    height: 44,
                    fontSize: 14,
                    onPressed: () => onNavigate(1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Ada Apa di Dinoyo ----------
  Widget _buildActivities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ada Apa di Dinoyo?',
                style: AppText.sans(size: 22, weight: FontWeight.w800),
              ),
            ),
            Text(
              'AKTIVITAS',
              style: AppText.sans(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.muted,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ActivityCard(
                  icon: Icons.palette_outlined,
                  tint: AppColors.peach,
                  iconColor: AppColors.primary,
                  title: 'Workshop',
                  description: 'Buat keramik bersama pengrajin.',
                  onTap: () => onNavigate(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActivityCard(
                  icon: Icons.storefront_outlined,
                  tint: AppColors.sage,
                  iconColor: AppColors.sageDark,
                  title: 'Jelajah',
                  description: 'Temukan karya & toko lokal.',
                  onTap: () => onNavigate(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActivityCard(
                  icon: Icons.place_outlined,
                  tint: AppColors.peach,
                  iconColor: AppColors.primary,
                  title: 'Kunjungi',
                  description: 'Temukan rute lokasi Dinoyo.',
                  onTap: () => _openMaps(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Cerita Dinoyo ----------
  Widget _buildStoryCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _toast(context, 'Halaman cerita akan hadir di tahap berikutnya.'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: const AssetPic(
                'assets/images/story.jpg',
                width: 84,
                height: 104,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CERITA DINOYO',
                    style: AppText.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dari tanah liat hingga menjadi identitas Dinoyo.',
                    style: AppText.sans(
                      size: 18,
                      weight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Baca Cerita',
                        style: AppText.sans(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Temukan Karya ----------
  Widget _buildProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Temukan Karya',
                style: AppText.sans(size: 22, weight: FontWeight.w800),
              ),
            ),
            GestureDetector(
              onTap: () => onNavigate(1),
              child: Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: AppText.sans(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 262,
          ),
          itemBuilder: (context, i) => _ProductCard(product: products[i]),
        ),
      ],
    );
  }

  // ---------- Kartu AI ----------
  Widget _buildAiCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        color: AppColors.peach,
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -44,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0x1AA23B15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cari Keramik dengan AI',
                          style: AppText.sans(size: 20, weight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan keramik sesuai kebutuhan dan gaya kamu secara instan dengan kurasi cerdas.',
                    style: AppText.sans(
                      size: 14,
                      color: AppColors.brown,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAiInfo(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.manage_search, size: 22),
                      label: Text(
                        'Cari dengan AI',
                        style: AppText.sans(
                          size: 15,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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

  // ---------- Rating ----------
  Widget _buildRatingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFE8820C), size: 28),
              const SizedBox(width: 8),
              Text(
                '4.8 / 5',
                style: AppText.sans(size: 26, weight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                '186 ulasan pengunjung',
                style: AppText.sans(size: 12, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"Pengalaman belajar memutar tanah liat langsung dari pengrajin senior Dinoyo sangat berkesan dan\u2026"',
            style: AppText.sans(
              size: 14,
              color: AppColors.brown,
              height: 1.5,
              style: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _toast(context, 'Halaman ulasan akan hadir di tahap berikutnya.'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Ulasan',
                    style: AppText.sans(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kunjungi ----------
  Widget _buildVisitCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Kunjungi Kampung Keramik Dinoyo',
                  style: AppText.sans(
                    size: 22,
                    weight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.sage,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.place_outlined,
                  color: AppColors.sageDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Jl. MT Haryono No. 336, Dinoyo, Malang',
            style: AppText.sans(size: 14, color: AppColors.brown),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(
                    child: AssetPic(
                      'assets/images/map.png',
                      fallbackColor: Color(0xFFE4EAE0),
                      fallbackIcon: Icons.map_outlined,
                      fallbackIconSize: 40,
                      fallbackIconColor: Color(0xFFA9B8A5),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.place,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kampung Dinoyo',
                          style: AppText.sans(size: 13, weight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton.icon(
              onPressed: () => _openMaps(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.field,
                foregroundColor: AppColors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.map_outlined, size: 20),
              label: Text(
                'Buka Google Maps',
                style: AppText.sans(
                  size: 15,
                  weight: FontWeight.w600,
                  color: AppColors.brown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= Widget kecil =======================

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppText.sans(size: 16, weight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppText.sans(
                  size: 13,
                  color: AppColors.brown,
                  height: 1.35,
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
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Detail ${product.name} akan hadir di tahap berikutnya.'),
              ),
            );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: double.infinity,
                    child: AssetPic(product.image),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.category,
                style: AppText.sans(
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 16, weight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(product.price),
                style: AppText.sans(
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}