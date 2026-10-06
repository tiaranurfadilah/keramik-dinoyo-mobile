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
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final error = AuthService.instance.login(_emailCtrl.text, _passCtrl.text);
    if (error != null) {
      _message(error);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
          child: Column(
            children: [
              // Logo + lencana centang
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned.fill(child: LogoMark(size: 130)),
                    Positioned(
                      right: 0,
                      bottom: 6,
                      child: Container(
                        width: 32,
                        height: 32,
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
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_outlined,
                      size: 18,
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
              const SizedBox(height: 18),
              Text(
                'Selamat Datang \u{1F44B}',
                textAlign: TextAlign.center,
                style: AppText.sans(size: 32, weight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Jelajahi cerita, kelas kriya, dan karya otentik Dinoyo, Malang.',
                textAlign: TextAlign.center,
                style: AppText.sans(
                  size: 16,
                  color: AppColors.brown,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Kartu form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthField(
                        label: 'Alamat Email',
                        hint: 'aditya.pratama@email.com',
                        icon: Icons.mail_outline,
                        controller: _emailCtrl,
                        fillColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        label: 'Kata Sandi',
                        hint: 'Masukkan kata sandi',
                        icon: Icons.lock_outline,
                        controller: _passCtrl,
                        fillColor: Colors.white,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.password,
                        labelTrailing: GestureDetector(
                          onTap: () =>
                              _message('Reset kata sandi akan hadir di tahap berikutnya.'),
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
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Masuk ke Akun',
                        showArrow: true,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                          const Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Material(
                        color: Colors.white,
                        shape: const StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () =>
                              _message('Login Google belum tersedia pada versi simulasi.'),
                          child: SizedBox(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'G',
                                  style: AppText.sans(
                                    size: 22,
                                    weight: FontWeight.w800,
                                    color: const Color(0xFF4285F4),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'Lanjutkan dengan Google',
                                  style: AppText.sans(
                                    size: 16,
                                    weight: FontWeight.w600,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: AppText.sans(size: 15, color: AppColors.brown),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
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
      ),
    );
  }
}