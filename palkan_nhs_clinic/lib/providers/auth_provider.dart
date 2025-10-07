import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _loading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _loading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin == true;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.login(username, password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(UserModel user, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _authService.register(user, password);
      _currentUser = user;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
