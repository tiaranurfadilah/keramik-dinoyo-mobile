class Validators {
  static String? required(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi.';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi.';
    final ok = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v.trim());
    return ok ? null : 'Format email tidak valid.';
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor WhatsApp wajib diisi.';
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(v.trim())) {
      return 'Nomor hanya boleh berisi angka.';
    }
    if (digits.length < 9 || digits.length > 15) {
      return 'Nomor harus 9 sampai 15 digit.';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Kata sandi wajib diisi.';
    if (v.length < 8) return 'Kata sandi minimal 8 karakter.';
    return null;
  }

  static String? Function(String?) confirm(String Function() original) {
    return (v) {
      if (v == null || v.isEmpty) return 'Ulangi kata sandi Anda.';
      if (v != original()) return 'Konfirmasi kata sandi tidak sama.';
      return null;
    };
  }
}