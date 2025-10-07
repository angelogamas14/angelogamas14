import '../models/bmi.dart';
import 'db_service.dart';

class BmiService {
  final DbService _db = DbService();

  Future<void> addBmi(BmiRecord record) async {
    final List<dynamic> list = _db.getJson<List<dynamic>>(_db.bmiBox, 'bmis') ?? [];
    list.add(record.toJson());
    await _db.putJson(_db.bmiBox, 'bmis', list);
  }

  Future<List<BmiRecord>> listByUser(String userId) async {
    final List<dynamic> list = _db.getJson<List<dynamic>>(_db.bmiBox, 'bmis') ?? [];
    return list
        .map((e) => BmiRecord.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((e) => e.userId == userId)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }
}
