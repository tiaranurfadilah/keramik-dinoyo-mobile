import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gambar dari assets. Jika file belum ada, tampil kotak pengganti.
class AssetPic extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData fallbackIcon;
  final double fallbackIconSize;
  final Color fallbackColor;
  final Color fallbackIconColor;
  final bool showFallbackIcon;

  const AssetPic(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallbackIcon = Icons.image_outlined,
    this.fallbackIconSize = 32,
    this.fallbackColor = const Color(0xFFE9DFD5),
    this.fallbackIconColor = const Color(0xFFB59B8A),
    this.showFallbackIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: fallbackColor,
        alignment: Alignment.center,
        child: showFallbackIcon
            ? Icon(fallbackIcon, color: fallbackIconColor, size: fallbackIconSize)
            : null,
      ),
    );
  }
}

class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AssetPic(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        fallbackColor: Colors.transparent,
        fallbackIcon: Icons.spa_outlined,
        fallbackIconSize: size * 0.6,
        fallbackIconColor: AppColors.primary,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool showArrow;
  final bool expand;
  final double height;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = false,
    this.expand = true,
    this.height = 56,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppText.sans(
                size: fontSize,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class AuthField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Color fillColor;
  final Widget? labelTrailing;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.fillColor = AppColors.field,
    this.labelTrailing,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _hidden = true;

  OutlineInputBorder _border(Color color, [double width = 0]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label.toUpperCase(),
                style: AppText.sans(
                  size: 13,
                  weight: FontWeight.w700,
                  color: AppColors.brown,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            if (widget.labelTrailing != null) widget.labelTrailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _hidden,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          style: AppText.sans(size: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            hintText: widget.hint,
            hintStyle: AppText.sans(size: 16, color: AppColors.muted),
            errorStyle: AppText.sans(size: 12, color: AppColors.error),
            prefixIcon: Icon(widget.icon, color: AppColors.brown, size: 22),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _hidden ? 'Tampilkan' : 'Sembunyikan',
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.brown,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: _border(Colors.transparent),
            enabledBorder: _border(Colors.transparent),
            focusedBorder: _border(AppColors.primary, 1.5),
            errorBorder: _border(AppColors.error, 1),
            focusedErrorBorder: _border(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }
}