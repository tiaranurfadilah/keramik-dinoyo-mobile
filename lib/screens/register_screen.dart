import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    AuthService.instance.register(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat.')));

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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris atas: tombol kembali + chip
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: AppColors.field,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.arrow_back, color: AppColors.ink),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'REGISTRASI',
                          style: AppText.sans(
                            size: 12,
                            weight: FontWeight.w700,
                            color: AppColors.brown,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Buat Akun Baru',
                style: AppText.sans(size: 34, weight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Mulai perjalananmu mengenal dan mencintai kerajinan Dinoyo.',
                style: AppText.sans(
                  size: 16,
                  color: AppColors.brown,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthField(
                      label: 'Nama Lengkap',
                      hint: 'Contoh: Andi',
                      icon: Icons.person_outline,
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(v, 'Nama lengkap'),
                    ),
                    const SizedBox(height: 18),
                    AuthField(
                      label: 'Email Aktif',
                      hint: 'Ardi@gmail.com',
                      icon: Icons.mail_outline,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 18),
                    AuthField(
                      label: 'Nomor WhatsApp / HP',
                      hint: '0812-3456-7890',
                      icon: Icons.phone_outlined,
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 18),
                    AuthField(
                      label: 'Kata Sandi',
                      hint: 'Minimal 8 karakter',
                      icon: Icons.lock_outline,
                      controller: _passCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 18),
                    AuthField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Ulangi kata sandi',
                      icon: Icons.lock_reset_outlined,
                      controller: _confirmCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirm(() => _passCtrl.text),
                    ),
                    const SizedBox(height: 22),

                    // Persetujuan
                    FormField<bool>(
                      initialValue: false,
                      validator: (v) => v == true
                          ? null
                          : 'Centang persetujuan untuk melanjutkan.',
                      builder: (state) {
                        final checked = state.value ?? false;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => state.didChange(!checked),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: checked
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: checked
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Saya sepakat mendukung pelestarian budaya tanah liat dan menghormati panduan kerajinan lokal Dinoyo.',
                                      style: AppText.sans(
                                        size: 14,
                                        color: AppColors.brown,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 36),
                                child: Text(
                                  state.errorText!,
                                  style: AppText.sans(
                                    size: 12,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Daftar Akun',
                showArrow: true,
                height: 58,
                fontSize: 18,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: AppText.sans(size: 15, color: AppColors.brown),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Masuk di sini',
                      style: AppText.sans(
                        size: 15,
                        weight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _Dot(),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'KAMPUNG KERAMIK DINOYO \u2022 MALANG, JAWA TIMUR',
                      textAlign: TextAlign.center,
                      style: AppText.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: AppColors.brown,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _Dot(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Color(0xFFB7D3B9),
        shape: BoxShape.circle,
      ),
    );
  }
}