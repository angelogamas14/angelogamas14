import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/app_provider.dart';
import 'routing.dart';
import 'theme.dart';

class PalkanApp extends StatelessWidget {
  const PalkanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Palkan NHS Clinic',
        theme: buildTheme(),
        initialRoute: Routes.splash,
        routes: routes,
      ),
    );
  }
}
