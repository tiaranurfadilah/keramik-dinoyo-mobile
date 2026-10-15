import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text)),
      );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final error = AuthService.instance.login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (error != null) {
      _message(error);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
      (route) => false,
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 60,
                ),
                child: Column(
                  children: [
                    // Logo dan lencana verifikasi
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Positioned.fill(
                            child: LogoMark(size: 130),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 5,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.sageDark,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Label kolektif
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_outlined,
                            size: 19,
                            color: AppColors.sageDark,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'KOLEKTIF KRIYA DINOYO',
                            style: AppText.sans(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.sageDark,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Judul sambutan
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Selamat Datang 👋',
                        textAlign: TextAlign.center,
                        style: AppText.sans(
                          size: 32,
                          weight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Jelajahi cerita, kelas kriya, dan karya otentik '
                      'Dinoyo, Malang.',
                      textAlign: TextAlign.center,
                      style: AppText.sans(
                        size: 16,
                        color: AppColors.brown,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Kartu login
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.025),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthField(
                              label: 'ALAMAT EMAIL',
                              hint: 'aditya.pratama@email.com',
                              icon: Icons.mail_outline,
                              controller: _emailCtrl,
                              fillColor: AppColors.background,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.email,
                            ),

                            const SizedBox(height: 22),

                            AuthField(
                              label: 'KATA SANDI',
                              hint: 'Masukkan kata sandi',
                              icon: Icons.lock_outline,
                              controller: _passCtrl,
                              fillColor: AppColors.background,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              validator: Validators.password,
                              labelTrailing: GestureDetector(
                                onTap: () {
                                  _message(
                                    'Reset kata sandi akan hadir '
                                    'di tahap berikutnya.',
                                  );
                                },
                                child: Text(
                                  'Lupa Sandi?',
                                  style: AppText.sans(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            PrimaryButton(
                              label: 'Masuk ke Akun',
                              showArrow: true,
                              onPressed: _submit,
                            ),

                            const SizedBox(height: 22),

                            // Pemisah login alternatif
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.border,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Text(
                                    'ATAU MASUK DENGAN',
                                    style: AppText.sans(
                                      size: 12,
                                      weight: FontWeight.w700,
                                      color: AppColors.brown,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.border,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            // Tombol Google
                            Material(
                              color: AppColors.background,
                              shape: const StadiumBorder(),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  _message(
                                    'Login Google belum tersedia '
                                    'pada versi simulasi.',
                                  );
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const _GoogleMark(),
                                      const SizedBox(width: 14),
                                      Text(
                                        'Lanjutkan dengan Google',
                                        style: AppText.sans(
                                          size: 16,
                                          weight: FontWeight.w600,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Tautan pendaftaran
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppText.sans(
                            size: 15,
                            color: AppColors.brown,
                          ),
                        ),
                        GestureDetector(
                          onTap: _openRegister,
                          child: Text(
                            'Daftar sekarang',
                            style: AppText.sans(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 25,
      height: 25,
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            foreground: null,
            color: Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}
