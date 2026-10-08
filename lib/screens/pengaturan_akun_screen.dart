import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class PengaturanAkunScreen extends StatefulWidget {
  const PengaturanAkunScreen({super.key});

  @override
  State<PengaturanAkunScreen> createState() => _PengaturanAkunScreenState();
}

class _PengaturanAkunScreenState extends State<PengaturanAkunScreen> {
  bool _notificationsEnabled = true;

  AuthService get _auth => AuthService.instance;

  @override
  Widget build(BuildContext context) {
    final name = _auth.currentName.trim().isEmpty
        ? 'Pengunjung'
        : _auth.currentName.trim();
    final email = _auth.currentEmail.isEmpty
        ? 'Email belum ditambahkan'
        : _auth.currentEmail;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Pengaturan Akun',
          style: AppText.sans(size: 20, weight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(name, email),
                      const SizedBox(height: 28),
                      Text(
                        'PENGATURAN AKUN',
                        style: AppText.sans(
                          size: 13,
                          weight: FontWeight.w800,
                          color: AppColors.brown,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildOptionsCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLogoutButton(),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.peach,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kampung Keramik Dinoyo • v1.2.0',
                    style: AppText.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.muted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _AccountAvatar(initial: name[0].toUpperCase(), size: 112),
              Positioned(
                right: -2,
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
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(name, style: AppText.sans(size: 27, weight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(email, style: AppText.sans(size: 16, color: AppColors.brown)),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: TextButton.icon(
              onPressed: _editProfile,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE8E5E0),
                foregroundColor: AppColors.ink,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              label: Text(
                'Edit Profil',
                style: AppText.sans(size: 16, weight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _AccountOption(
            icon: Icons.person_outline,
            title: 'Informasi Pribadi',
            subtitle: 'Nama, email, nomor WhatsApp',
            onTap: _editProfile,
          ),
          const _AccountDivider(),
          _AccountOption(
            icon: Icons.lock_outline,
            title: 'Ubah Kata Sandi',
            subtitle: 'Perbarui kata sandi akun',
            onTap: _showPasswordInfo,
          ),
          const _AccountDivider(),
          _AccountOption(
            icon: Icons.notifications_none,
            title: 'Notifikasi',
            subtitle: 'Pemberitahuan workshop & aktivitas',
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeThumbColor: AppColors.primary,
              onChanged: (value) =>
                  setState(() => _notificationsEnabled = value),
            ),
            onTap: () => setState(
              () => _notificationsEnabled = !_notificationsEnabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton.icon(
        onPressed: _logout,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFDCD7),
          foregroundColor: AppColors.primary,
          shape: const StadiumBorder(),
        ),
        icon: const Icon(Icons.logout, size: 21),
        label: Text(
          'Keluar dari Akun',
          style: AppText.sans(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _auth.currentName);
    final emailController = TextEditingController(text: _auth.currentEmail);
    final phoneController = TextEditingController(text: _auth.currentPhone);
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          'Informasi Pribadi',
          style: AppText.sans(size: 20, weight: FontWeight.w800),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EditProfileField(
                  controller: nameController,
                  label: 'Nama',
                  keyboardType: TextInputType.name,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Nama wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 12),
                _EditProfileField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi.';
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value.trim())) {
                      return 'Format email tidak valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _EditProfileField(
                  controller: phoneController,
                  label: 'Nomor WhatsApp',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Batal',
              style: AppText.sans(size: 14, color: AppColors.brown),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Simpan',
              style: AppText.sans(
                size: 14,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (saved == true && mounted) {
      _auth.updateProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );
      setState(() {});
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
              content: Text('Informasi profil berhasil diperbarui.')),
        );
    }

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  void _showPasswordInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Ubah Kata Sandi',
          style: AppText.sans(size: 20, weight: FontWeight.w800),
        ),
        content: Text(
          'Penggantian kata sandi belum tersedia pada versi aplikasi ini.',
          style: AppText.sans(size: 14, color: AppColors.brown, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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

  void _logout() {
    AuthService.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  final String initial;
  final double size;

  const _AccountAvatar({required this.initial, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.sage,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 5),
      ),
      child: Text(
        initial,
        style: AppText.sans(
          size: size * 0.42,
          weight: FontWeight.w800,
          color: AppColors.sageDark,
        ),
      ),
    );
  }
}

class _AccountOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _AccountOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.field,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 25, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.sans(size: 17, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(size: 13, color: AppColors.brown),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing ??
                  const Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: AppColors.muted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  const _AccountDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 74),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _EditProfileField({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: AppText.sans(size: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppText.sans(size: 13, color: AppColors.brown),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
