class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  String? _registeredName;
  String? _registeredEmail;
  String? _registeredPassword;

  String currentName = 'Pengunjung';
  String currentEmail = '';

  String get firstName {
    final parts = currentName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty || parts.first.isEmpty ? 'Pengunjung' : parts.first;
  }

  void register({
    required String name,
    required String email,
    required String password,
  }) {
    _registeredName = name.trim();
    _registeredEmail = email.trim().toLowerCase();
    _registeredPassword = password;
    currentName = _registeredName!;
    currentEmail = _registeredEmail!;
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  String? login(String email, String password) {
    final e = email.trim().toLowerCase();

    if (_registeredEmail != null && _registeredEmail == e) {
      if (_registeredPassword != password) {
        return 'Email atau kata sandi salah.';
      }
      currentName = _registeredName ?? 'Pengunjung';
      currentEmail = e;
      return null;
    }

    // Mode simulasi: email lain yang formatnya valid tetap bisa masuk.
    final local = e.split('@').first.replaceAll(RegExp(r'[._]+'), ' ').trim();
    currentName = local.isEmpty
        ? 'Pengunjung'
        : local[0].toUpperCase() + local.substring(1);
    currentEmail = e;
    return null;
  }

  void logout() {
    currentName = 'Pengunjung';
    currentEmail = '';
  }
}