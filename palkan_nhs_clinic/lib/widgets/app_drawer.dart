import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routing.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.currentUser?.fullName ?? 'Guest'),
              accountEmail: Text(auth.currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(auth.currentUser?.photoUrl ??
                    'https://i.pravatar.cc/150?img=1'),
              ),
            ),
            _item(context, Icons.home, 'Home', Routes.home),
            _item(context, Icons.monitor_weight, 'BMI', Routes.bmi),
            _item(context, Icons.person, 'Profile', Routes.profile),
            _item(context, Icons.warning_amber, 'Allergies', Routes.allergies),
            _item(context, Icons.medication, 'Medicine', Routes.medicine),
            _item(context, Icons.restaurant_menu, 'Foods', Routes.foods),
            if (auth.isAdmin)
              _item(context, Icons.dashboard, 'Admin', Routes.adminDashboard),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.login, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _item(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}
