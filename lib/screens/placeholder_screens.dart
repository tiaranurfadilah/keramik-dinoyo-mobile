import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

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
              Text(title, style: AppText.sans(size: 24, weight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppText.sans(size: 15, color: AppColors.brown, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final initial =
        auth.currentName.isEmpty ? 'P' : auth.currentName[0].toUpperCase();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profil', style: AppText.sans(size: 28, weight: FontWeight.w800)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initial,
                      style: AppText.sans(
                        size: 22,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.currentName,
                          style: AppText.sans(size: 18, weight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.currentEmail.isEmpty ? '-' : auth.currentEmail,
                          style: AppText.sans(size: 14, color: AppColors.brown),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Keluar',
              onPressed: () {
                AuthService.instance.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}