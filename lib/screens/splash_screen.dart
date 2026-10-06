import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AssetPic(
            'assets/images/splash_bg.jpg',
            fallbackColor: Color(0xFFE9DFD5),
            showFallbackIcon: false,
          ),
          // Lapisan putih transparan seperti di desain
          Container(color: const Color.fromRGBO(242, 238, 232, 0.78)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Container(
                    width: 190,
                    height: 190,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(120, 120, 120, 0.25),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const LogoMark(size: 110),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'KAMPUNG KERAMIK',
                      style: AppText.sans(size: 30, weight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    'DINOYO',
                    style: AppText.sans(
                      size: 34,
                      weight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(width: 90, height: 1.5, color: AppColors.ink),
                  const SizedBox(height: 14),
                  Text(
                    '\u201CDari tanah menjadi cerita\u201D',
                    textAlign: TextAlign.center,
                    style: AppText.serif(
                      size: 18,
                      weight: FontWeight.w500,
                      style: FontStyle.italic,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Eksplorasi keramik. Temukan berbagai karya keramik dari pengrajin lokal Dinoyo.',
                    textAlign: TextAlign.center,
                    style: AppText.sans(
                      size: 14,
                      color: AppColors.brown,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(flex: 3),
                  PrimaryButton(
                    label: 'Mulai Eksplorasi',
                    expand: false,
                    height: 52,
                    fontSize: 15,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                  const Spacer(),
                  Container(width: 90, height: 2, color: AppColors.primary),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}