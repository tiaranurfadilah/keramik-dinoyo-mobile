import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'pengaturan_akun_screen.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(title,
                  style: AppText.sans(size: 24, weight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style:
                    AppText.sans(size: 15, color: AppColors.brown, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final name =
        auth.currentName.trim().isEmpty ? 'Pengunjung' : auth.currentName;
    final email = auth.currentEmail.isEmpty
        ? 'Email belum ditambahkan'
        : auth.currentEmail;
    final initial = name[0].toUpperCase();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DINOYO HERITAGE',
                        style: AppText.sans(
                          size: 13,
                          weight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.7,
                        ),
                      ),
                      Text(
                        'Profil',
                        style: AppText.sans(size: 28, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                _ProfileAvatar(initial: initial, size: 48),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _ProfileAvatar(initial: initial, size: 118),
                      Positioned(
                        right: -4,
                        bottom: -2,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(name,
                      style: AppText.sans(size: 27, weight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(email,
                      style: AppText.sans(size: 16, color: AppColors.brown)),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.palette,
                            size: 18, color: AppColors.sageDark),
                        const SizedBox(width: 8),
                        Text(
                          'PECINTA KARYA DINOYO',
                          style: AppText.sans(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.brown,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const _ProfileSectionTitle(title: 'AKTIVITAS SAYA'),
            const SizedBox(height: 12),
            _ProfileActionCard(
              icon: Icons.handyman_outlined,
              iconColor: AppColors.sageDark,
              iconBackground: AppColors.sage,
              title: 'Workshop Saya',
              subtitle: 'Belum ada workshop terdaftar',
              badge: '0 Aktif',
              badgeColor: AppColors.sage,
              onTap: () => _showProfileMessage(
                context,
                'Riwayat workshop akan muncul di sini setelah kamu mendaftar kegiatan.',
              ),
            ),
            const SizedBox(height: 10),
            _ProfileActionCard(
              icon: Icons.star,
              iconColor: AppColors.primary,
              iconBackground: AppColors.peach,
              title: 'Ulasan Saya',
              subtitle: 'Belum ada ulasan',
              badge: '0 Ulasan',
              badgeColor: AppColors.field,
              onTap: () => _showProfileMessage(
                context,
                'Ulasan yang kamu kirim akan ditampilkan di sini.',
              ),
            ),
            const SizedBox(height: 28),
            const _ProfileSectionTitle(title: 'PENGATURAN'),
            const SizedBox(height: 12),
            _ProfileActionCard(
              icon: Icons.manage_accounts_outlined,
              iconColor: AppColors.brown,
              iconBackground: const Color(0xFFE8E5E0),
              title: 'Pengaturan Akun',
              subtitle: 'Data diri, keamanan & privasi',
              onTap: _openAccountSettings,
            ),
            const SizedBox(height: 10),
            _ProfileActionCard(
              icon: Icons.help_outline,
              iconColor: AppColors.brown,
              iconBackground: const Color(0xFFE8E5E0),
              title: 'Bantuan',
              subtitle: 'FAQ, kontak pengrajin & panduan',
              onTap: () => _showProfileMessage(
                context,
                'Untuk bertanya tentang karya, buka detail produk lalu pilih Hubungi Pengrajin.',
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton.icon(
                onPressed: () => _logout(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFCEAE5),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.logout, size: 21),
                label: Text(
                  'Keluar Akun',
                  style: AppText.sans(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    'KAMPUNG KERAMIK DINOYO V1.2.0 • MALANG',
                    textAlign: TextAlign.center,
                    style: AppText.sans(
                      size: 11,
                      weight: FontWeight.w800,
                      color: AppColors.muted,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Lestarikan Warisan Tanah & Api',
                    style: AppText.sans(size: 14, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    AuthService.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _openAccountSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PengaturanAkunScreen(),
      ),
    );
    if (mounted) setState(() {});
  }

  void _showProfileMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String initial;
  final double size;

  const _ProfileAvatar({required this.initial, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.sage,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: size > 60 ? 4 : 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        initial,
        style: AppText.sans(
          size: size * 0.4,
          weight: FontWeight.w800,
          color: AppColors.sageDark,
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;

  const _ProfileSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppText.sans(
        size: 13,
        weight: FontWeight.w800,
        color: AppColors.brown,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String? badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ProfileActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.badgeColor = AppColors.field,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, size: 26, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.sans(size: 16, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.sans(size: 13, color: AppColors.brown),
                    ),
                  ],
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    badge!,
                    style: AppText.sans(
                      size: 11,
                      weight: FontWeight.w700,
                      color: AppColors.sageDark,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: AppColors.muted, size: 23),
            ],
          ),
        ),
      ),
    );
  }
}
