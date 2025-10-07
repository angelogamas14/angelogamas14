import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../routing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Palkan NHS Clinic'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
                tooltip: 'Notifications',
              ),
              if (app.pendingNotifications > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:
                        const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      app.pendingNotifications.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(auth.currentUser?.photoUrl ??
                    'https://i.pravatar.cc/150?img=3'),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome, ${auth.currentUser?.fullName ?? 'Guest'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              if (app.latestBmi != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text('Your latest BMI: ${app.latestBmi!.bmi.toStringAsFixed(1)}'),
                        Text('Status: '
                            '${app.latestBmi != null ? _classify(app.latestBmi!.bmi) : ''}'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _quickButton(context, Icons.monitor_weight, 'BMI', Routes.bmi),
                  _quickButton(context, Icons.person, 'Profile', Routes.profile),
                  _quickButton(context, Icons.warning_amber, 'Allergies', Routes.allergies),
                  _quickButton(context, Icons.medication, 'Medicine', Routes.medicine),
                  _quickButton(context, Icons.restaurant_menu, 'Foods', Routes.foods),
                  if (auth.isAdmin)
                    _quickButton(context, Icons.dashboard, 'Admin', Routes.adminDashboard),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickButton(BuildContext context, IconData icon, String title, String route) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      icon: Icon(icon),
      label: Text(title),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }

  String _classify(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obesity';
  }
}
