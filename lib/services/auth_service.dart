class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  String? _registeredName;
  String? _registeredEmail;
  String? _registeredPassword;
  String? _registeredPhone;

  String currentName = 'Pengunjung';
  String currentEmail = '';
  String currentPhone = '';

  String get firstName {
    final parts = currentName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty || parts.first.isEmpty ? 'Pengunjung' : parts.first;
  }

  void register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    _registeredName = name.trim();
    _registeredEmail = email.trim().toLowerCase();
    _registeredPassword = password;
    _registeredPhone = phone.trim();
    currentName = _registeredName!;
    currentEmail = _registeredEmail!;
    currentPhone = _registeredPhone!;
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    currentName = name.trim();
    currentEmail = email.trim().toLowerCase();
    currentPhone = phone.trim();

    if (_registeredEmail != null) {
      _registeredName = currentName;
      _registeredEmail = currentEmail;
      _registeredPhone = currentPhone;
    }
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
      currentPhone = _registeredPhone ?? '';
      return null;
    }

    // Mode simulasi: email lain yang formatnya valid tetap bisa masuk.
    final local = e.split('@').first.replaceAll(RegExp(r'[._]+'), ' ').trim();
    currentName = local.isEmpty
        ? 'Pengunjung'
        : local[0].toUpperCase() + local.substring(1);
    currentEmail = e;
    currentPhone = '';
    return null;
  }

  void logout() {
    currentName = 'Pengunjung';
    currentEmail = '';
    currentPhone = '';
  }
}