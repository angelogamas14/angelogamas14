import 'dart:math';
import '../models/medicine.dart';
import 'db_service.dart';

class MedicineService {
  final DbService _db = DbService();

  Future<void> upsertSchedule(MedicineSchedule schedule) async {
    final Map<String, dynamic> byUser =
        _db.getJson<Map<String, dynamic>>(_db.medsBox, 'medsByUser') ?? {};
    final list = (byUser[schedule.userId] as List?) ?? [];
    final idx = list.indexWhere((e) => e['id'] == schedule.id);
    if (idx >= 0) {
      list[idx] = schedule.toJson();
    } else {
      list.add(schedule.toJson());
    }
    byUser[schedule.userId] = list;
    await _db.putJson(_db.medsBox, 'medsByUser', byUser);
  }

  Future<void> deleteSchedule(String userId, String scheduleId) async {
    final Map<String, dynamic> byUser =
        _db.getJson<Map<String, dynamic>>(_db.medsBox, 'medsByUser') ?? {};
    final list = (byUser[userId] as List?) ?? [];
    list.removeWhere((e) => e['id'] == scheduleId);
    byUser[userId] = list;
    await _db.putJson(_db.medsBox, 'medsByUser', byUser);
  }

  Future<List<MedicineSchedule>> listSchedules(String userId) async {
    final Map<String, dynamic> byUser =
        _db.getJson<Map<String, dynamic>>(_db.medsBox, 'medsByUser') ?? {};
    final list = (byUser[userId] as List?) ?? [];
    return list
        .map((e) => MedicineSchedule.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.nextDoseAt.compareTo(b.nextDoseAt));
  }
}
