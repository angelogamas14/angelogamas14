import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../services/notifications_service.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  late Future<List<MedicineSchedule>> _future;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().currentUser!.id;
    _future = MedicineService().listSchedules(userId);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthProvider>().currentUser!.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Medicine Reminders')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openEditor(userId),
      ),
      body: FutureBuilder<List<MedicineSchedule>>(
        future: _future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No schedules. Tap + to add.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final s = items[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.medication),
                  title: Text('${s.medicineName} (${s.dosage})'),
                  subtitle: Text('${s.instructions}\nNext: ${s.nextDoseAt}'),
                  isThreeLine: true,
                  trailing: Switch(
                    value: s.enabled,
                    onChanged: (v) async {
                      final updated = s.copyWith(enabled: v);
                      await MedicineService().upsertSchedule(updated);
                      setState(() => _future = MedicineService().listSchedules(userId));
                    },
                  ),
                  onLongPress: () async {
                    await MedicineService().deleteSchedule(userId, s.id);
                    setState(() => _future = MedicineService().listSchedules(userId));
                    await NotificationsService().cancel(s.hashCode);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openEditor(String userId) async {
    final nameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    final instrCtrl = TextEditingController();
    TimeOfDay time = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Medicine name')),
              TextField(controller: doseCtrl, decoration: const InputDecoration(labelText: 'Dosage')),
              TextField(controller: instrCtrl, decoration: const InputDecoration(labelText: 'Instructions')),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.schedule),
                label: Text('Time: ${time.format(context)}'),
                onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: time);
                  if (picked != null) {
                    time = picked;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final next = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                final schedule = MedicineSchedule(
                  id: const Uuid().v4(),
                  userId: userId,
                  medicineName: nameCtrl.text.trim(),
                  dosage: doseCtrl.text.trim(),
                  instructions: instrCtrl.text.trim(),
                  nextDoseAt: next.isBefore(now) ? next.add(const Duration(days: 1)) : next,
                );
                await MedicineService().upsertSchedule(schedule);
                setState(() => _future = MedicineService().listSchedules(userId));
                await NotificationsService().scheduleAt(
                  id: schedule.hashCode,
                  title: 'Medicine reminder',
                  body: '${schedule.medicineName} - ${schedule.dosage}',
                  scheduledAt: schedule.nextDoseAt,
                );
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
