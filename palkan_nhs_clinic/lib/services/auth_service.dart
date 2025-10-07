import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'db_service.dart';

class AuthService {
  final DbService _db = DbService();
  static const String usersKey = 'users'; // Map<String username, Map>
  static const String currentUserKey = 'currentUser';

  Future<void> ensureDefaultAdmin() async {
    final box = _db.authBox;
    final Map<String, dynamic> users = (_db.getJson<Map<String, dynamic>>(box, usersKey)) ?? {};

    if (!users.containsKey('admin')) {
      final adminUser = UserModel(
        id: const Uuid().v4(),
        username: 'admin',
        fullName: 'Administrator',
        email: 'admin@example.com',
        phone: '',
        address: '',
        photoUrl: 'https://i.pravatar.cc/150?img=1',
        birthDate: DateTime(1990, 1, 1),
        hospitalHistory: '',
        allergies: const [],
        isAdmin: true,
      );
      users['admin'] = {
        'user': adminUser.toJson(),
        'password': '123',
      };
      await _db.putJson(box, usersKey, users);
    }
  }

  Future<UserModel?> login(String username, String password) async {
    final box = _db.authBox;
    final Map<String, dynamic> users = (_db.getJson<Map<String, dynamic>>(box, usersKey)) ?? {};
    final entry = users[username];
    if (entry == null) return null;
    if (entry['password'] != password) return null;
    final user = UserModel.fromJson(Map<String, dynamic>.from(entry['user']));
    await _db.putJson(box, currentUserKey, user.toJson());
    return user;
  }

  Future<void> register(UserModel user, String password) async {
    final box = _db.authBox;
    final Map<String, dynamic> users = (_db.getJson<Map<String, dynamic>>(box, usersKey)) ?? {};

    if (users.containsKey(user.username)) {
      throw Exception('Username already exists');
    }

    users[user.username] = {
      'user': user.toJson(),
      'password': password,
    };

    await _db.putJson(box, usersKey, users);
    await _db.putJson(box, currentUserKey, user.toJson());
  }

  Future<UserModel?> getCurrentUser() async {
    final json = _db.getJson<Map<String, dynamic>>(_db.authBox, currentUserKey);
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  Future<void> logout() async {
    await _db.authBox.delete(currentUserKey);
  }

  Future<List<UserModel>> listUsers() async {
    final box = _db.authBox;
    final Map<String, dynamic> users = (_db.getJson<Map<String, dynamic>>(box, usersKey)) ?? {};
    return users.values
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e['user'])))
        .toList()
      ..sort((a, b) => a.username.compareTo(b.username));
  }

  Future<void> updateUser(UserModel user) async {
    final box = _db.authBox;
    final Map<String, dynamic> users = (_db.getJson<Map<String, dynamic>>(box, usersKey)) ?? {};
    if (!users.containsKey(user.username)) return;
    final entry = users[user.username];
    entry['user'] = user.toJson();
    await _db.putJson(box, usersKey, users);
    await _db.putJson(box, currentUserKey, user.toJson());
  }
}
