import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routing.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../services/notifications_service.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await DbService().init();
    await AuthService().ensureDefaultAdmin();
    await NotificationsService().init();

    final user = await AuthService().getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      context.read<AuthProvider>().setCurrentUser(user);
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
