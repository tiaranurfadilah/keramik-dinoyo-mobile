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
          // Background foto keramik
          const AssetPic(
            'assets/images/splash_bg.jpg',
            fallbackColor: Color(0xFFE9DFD5),
            showFallbackIcon: false,
          ),

          // Overlay krem transparan
          Container(
            color: const Color.fromRGBO(242, 238, 232, 0.60),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.07),

                      // Logo lingkaran putih
                      Container(
                        width: 190,
                        height: 190,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(100, 94, 84, 0.30),
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

                      SizedBox(height: screenHeight * 0.09),

                      // Judul utama
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'KAMPUNG KERAMIK',
                          textAlign: TextAlign.center,
                          style: AppText.sans(
                            size: 30,
                            weight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),

                      // Nama lokasi
                      Text(
                        'DINOYO',
                        textAlign: TextAlign.center,
                        style: AppText.sans(
                          size: 34,
                          weight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: 62,
                        height: 1.5,
                        color: AppColors.ink,
                      ),

                      const SizedBox(height: 16),

                      // Tagline
                      Text(
                        '“Dari tanah menjadi cerita”',
                        textAlign: TextAlign.center,
                        style: AppText.serif(
                          size: 18,
                          weight: FontWeight.w600,
                          style: FontStyle.italic,
                          color: AppColors.brown,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Deskripsi
                      Text(
                        'Eksplorasi Keramik. Temukan berbagai karya '
                        'keramik dari pengrajin lokal Dinoyo.',
                        textAlign: TextAlign.center,
                        style: AppText.sans(
                          size: 14,
                          color: AppColors.brown,
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      // Tombol Mulai Eksplorasi
                      PrimaryButton(
                        label: 'Mulai Eksplorasi',
                        expand: false,
                        height: 52,
                        fontSize: 15,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: screenHeight * 0.12),

                      // Indikator bawah
                      Container(
                        width: 90,
                        height: 2,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
