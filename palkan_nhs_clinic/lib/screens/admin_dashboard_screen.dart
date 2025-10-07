import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  StreamSubscription<Map<String, dynamic>>? _sub;
  Map<String, dynamic>? _data;
  final AuthService _auth = AuthService();
  List<UserModel> _users = const [];

  @override
  void initState() {
    super.initState();
    _sub = _analytics.watchAnalytics().listen((d) {
      setState(() => _data = d);
    });
    _loadUsers();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: d == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _statCard('Total Users', d['totalUsers'].toString(), Icons.people),
                      _statCard('Medicine Schedules', d['medsCount'].toString(), Icons.medication),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('BMI Distribution', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 280,
                            child: SfCircularChart(
                              legend: const Legend(isVisible: true),
                              series: <PieSeries<_BmiData, String>>[
                                PieSeries<_BmiData, String>(
                                  dataSource: _toBmiData(d['bmiDistribution'] as Map<String, dynamic>),
                                  xValueMapper: (_BmiData bd, _) => bd.label,
                                  yValueMapper: (_BmiData bd, _) => bd.count,
                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Users', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Username')),
                                DataColumn(label: Text('Full name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Allergies')),
                              ],
                              rows: _users
                                  .map(
                                    (u) => DataRow(cells: [
                                      DataCell(Text(u.username)),
                                      DataCell(Text(u.fullName)),
                                      DataCell(Text(u.email)),
                                      DataCell(Text(u.allergies.join(', '))),
                                    ]),
                                  )
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<_BmiData> _toBmiData(Map<String, dynamic> m) {
    return m.entries.map((e) => _BmiData(e.key, (e.value as num).toInt())).toList();
  }

  Widget _statCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUsers() async {
    final users = await _auth.listUsers();
    if (!mounted) return;
    setState(() => _users = users);
  }
}

class _BmiData {
  final String label;
  final int count;
  _BmiData(this.label, this.count);
}
