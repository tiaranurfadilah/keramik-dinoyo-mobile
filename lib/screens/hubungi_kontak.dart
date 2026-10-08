import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

enum _ContactMethod { whatsapp, phone }

class ArtisanContactScreen extends StatefulWidget {
  final Product product;
  final String? phoneNumber;

  const ArtisanContactScreen({
    super.key,
    required this.product,
    this.phoneNumber,
  });

  @override
  State<ArtisanContactScreen> createState() => _ArtisanContactScreenState();
}

class _ArtisanContactScreenState extends State<ArtisanContactScreen> {
  _ContactMethod _method = _ContactMethod.whatsapp;

  Product get product => widget.product;
  String? get phoneNumber => widget.phoneNumber;

  String get _message =>
      'Halo $_artisanFirstName, saya tertarik dengan ${product.name} '
      '(${formatRupiah(product.price)}) yang ada di aplikasi Kampung Keramik '
      'Dinoyo. Apakah produknya masih tersedia?';

  String get _artisanFirstName {
    final name = product.shopName;
    if (name.startsWith('Studio ')) return name.substring('Studio '.length);
    if (name.startsWith('Toko Keramik ')) {
      return name.substring('Toko Keramik '.length);
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Hubungi Pengrajin',
          style: AppText.sans(size: 20, weight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationLine(),
              const SizedBox(height: 20),
              _buildArtisanCard(),
              const SizedBox(height: 34),
              Text(
                'Hubungi Pengrajin',
                style: AppText.sans(size: 28, weight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Untuk menanyakan ketersediaan, konsultasi glasir, atau informasi karya keramik buatan tangan ini.',
                style: AppText.sans(
                  size: 16,
                  color: AppColors.brown,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 26),
              _buildCommunicationHeading(),
              const SizedBox(height: 12),
              _ContactOption(
                title: 'WhatsApp Studio',
                subtitle: phoneNumber == null
                    ? 'Nomor WhatsApp belum tersedia'
                    : '$phoneNumber (Online)',
                icon: Icons.message_outlined,
                selected: _method == _ContactMethod.whatsapp,
                badge: 'Respon Cepat',
                onTap: () => setState(() => _method = _ContactMethod.whatsapp),
              ),
              const SizedBox(height: 10),
              _ContactOption(
                title: 'Panggilan Langsung',
                subtitle: phoneNumber == null
                    ? 'Nomor telepon belum tersedia'
                    : 'Bicara langsung dengan pengrajin',
                icon: Icons.call_outlined,
                selected: _method == _ContactMethod.phone,
                onTap: () => setState(() => _method = _ContactMethod.phone),
              ),
              const SizedBox(height: 18),
              _buildMessageTemplate(),
              const SizedBox(height: 18),
              _buildResponseInfo(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _continueContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  icon: Icon(
                    _method == _ContactMethod.whatsapp
                        ? Icons.send_rounded
                        : Icons.call,
                    size: 20,
                  ),
                  label: Text(
                    _method == _ContactMethod.whatsapp
                        ? 'Lanjut ke WhatsApp'
                        : 'Lakukan Panggilan',
                    style: AppText.sans(
                      size: 16,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationLine() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.sage,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.sageDark,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'SENTRA KERAMIK DINOYO',
                style: AppText.sans(
                  size: 11,
                  weight: FontWeight.w800,
                  color: AppColors.sageDark,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          'MALANG, JAWA TIMUR',
          style: AppText.sans(
            size: 10,
            weight: FontWeight.w800,
            color: AppColors.muted,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  Widget _buildArtisanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: const AssetPic(
                  'assets/images/pengrajin.jpg',
                  width: 72,
                  height: 72,
                  fallbackColor: Color(0xFFE8D8CA),
                  fallbackIcon: Icons.person_outline,
                  fallbackIconSize: 42,
                ),
              ),
              Positioned(
                right: -3,
                bottom: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.shopName == 'Studio Pak Slamet'
                      ? 'Studio Pak Slamet Riyadi'
                      : product.shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(size: 17, weight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    const Icon(Icons.star, size: 17, color: AppColors.primary),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: AppText.sans(size: 14, weight: FontWeight.w700),
                    ),
                    Text(
                      '(${product.ratingCount} ulasan)',
                      style: AppText.sans(size: 12, color: AppColors.muted),
                    ),
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.sageDark,
                    ),
                    Text(
                      'Terverifikasi',
                      style: AppText.sans(size: 12, color: AppColors.sageDark),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 17,
                      color: AppColors.brown,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Dinoyo, Kota Malang',
                      style: AppText.sans(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.brown,
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

  Widget _buildCommunicationHeading() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Pilih Jalur Komunikasi',
            style: AppText.sans(size: 16, weight: FontWeight.w700),
          ),
        ),
        const Icon(Icons.access_time, size: 16, color: AppColors.sageDark),
        const SizedBox(width: 4),
        Text(
          'Jam Aktif 08.00–17.00',
          style: AppText.sans(
            size: 11,
            weight: FontWeight.w800,
            color: AppColors.sageDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTemplate() {
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
              const Icon(Icons.edit_note, size: 23, color: AppColors.brown),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Template Pesan Otomatis',
                  style: AppText.sans(size: 15, weight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: _copyMessage,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                icon: const Icon(Icons.copy_outlined, size: 16),
                label: Text(
                  'SALIN TEKS',
                  style: AppText.sans(
                    size: 11,
                    weight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildProductMiniCard(),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '“$_message”',
              style: AppText.sans(
                size: 14,
                color: AppColors.ink,
                height: 1.6,
                style: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductMiniCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AssetPic(
              product.image,
              width: 62,
              height: 62,
              fallbackColor: const Color(0xFFE9D4C0),
              fallbackIcon: Icons.local_cafe_outlined,
              fallbackIconSize: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KARYA DITANYAKAN',
                  style: AppText.sans(
                    size: 10,
                    weight: FontWeight.w800,
                    color: AppColors.brown,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(size: 14, weight: FontWeight.w800),
                ),
                Text(
                  formatRupiah(product.price),
                  style: AppText.sans(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 19, color: AppColors.brown),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pengrajin biasanya membalas dalam waktu 15–30 menit pada jam operasional studio (08.00–17.00 WIB).',
              style: AppText.sans(
                size: 13,
                color: AppColors.brown,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.field,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.water_drop_outlined, color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(
            'GERABAH & KERAMIK DINOYO EST. 1957',
            textAlign: TextAlign.center,
            style: AppText.sans(
              size: 11,
              weight: FontWeight.w800,
              color: AppColors.muted,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyMessage() async {
    await Clipboard.setData(ClipboardData(text: _message));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Template pesan berhasil disalin.')),
      );
  }

  Future<void> _continueContact() async {
    final number = phoneNumber?.replaceAll(RegExp(r'[^0-9+]'), '');
    if (number == null || number.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Nomor kontak pengrajin belum tersedia.'),
          ),
        );
      return;
    }

    final uri = switch (_method) {
      _ContactMethod.whatsapp => Uri.https(
          'wa.me',
          '/${number.replaceFirst(RegExp(r'^\+'), '')}',
          {'text': _message},
        ),
      _ContactMethod.phone => Uri(scheme: 'tel', path: number),
    };

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi kontak.')),
      );
  }
}

class _ContactOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;

  const _ContactOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.field : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: selected ? AppColors.peach : AppColors.field,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    color: selected ? AppColors.primary : AppColors.brown),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style:
                              AppText.sans(size: 15, weight: FontWeight.w700),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sage,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              badge!,
                              style: AppText.sans(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.sageDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppText.sans(size: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.primary : AppColors.border,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
