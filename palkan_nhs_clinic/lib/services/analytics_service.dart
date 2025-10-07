import 'dart:async';
import 'dart:convert';
import '../models/bmi.dart';
import '../models/user.dart';
import 'db_service.dart';
import 'auth_service.dart';

class AnalyticsService {
  final DbService _db = DbService();
  final AuthService _auth = AuthService();

  // Emits analytics map with keys: totalUsers, bmiDistribution, medsCount
  Stream<Map<String, dynamic>> watchAnalytics() async* {
    // Initial emit
    yield await _computeAnalytics();

    final subs = <StreamSubscription>[];
    // Watch multiple boxes for changes
    subs.add(_db.authBox.watch().listen((_) async {}));
    subs.add(_db.bmiBox.watch().listen((_) async {}));
    subs.add(_db.medsBox.watch().listen((_) async {}));

    // Periodic poll to avoid complex per-key logic with stringified JSON
    final ticker = Stream.periodic(const Duration(seconds: 2));
    await for (final _ in ticker) {
      yield await _computeAnalytics();
    }
  }

  Future<Map<String, dynamic>> _computeAnalytics() async {
    final users = await _auth.listUsers();
    final List<dynamic> bmiListRaw = _db.getJson<List<dynamic>>(_db.bmiBox, 'bmis') ?? [];
    final bmis = bmiListRaw
        .map((e) => BmiRecord.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final medsByUser = _db.getJson<Map<String, dynamic>>(_db.medsBox, 'medsByUser') ?? {};
    int medsCount = 0;
    for (final entry in medsByUser.values) {
      medsCount += (entry as List).length;
    }

    final distribution = <String, int>{
      'Underweight': 0,
      'Normal': 0,
      'Overweight': 0,
      'Obesity': 0,
    };
    for (final bmi in bmis) {
      final cls = BmiRecord.classify(bmi.bmi);
      distribution[cls] = (distribution[cls] ?? 0) + 1;
    }

    return {
      'totalUsers': users.length,
      'bmiDistribution': distribution,
      'medsCount': medsCount,
    };
  }
}
