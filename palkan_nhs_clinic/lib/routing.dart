import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/allergies_screen.dart';
import 'screens/medicine_screen.dart';
import 'screens/foods_screen.dart';
import 'screens/admin_dashboard_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const bmi = '/bmi';
  static const profile = '/profile';
  static const allergies = '/allergies';
  static const medicine = '/medicine';
  static const foods = '/foods';
  static const adminDashboard = '/admin';
}

final routes = <String, WidgetBuilder>{
  Routes.splash: (_) => const SplashScreen(),
  Routes.login: (_) => const LoginScreen(),
  Routes.register: (_) => const RegisterScreen(),
  Routes.home: (_) => const HomeScreen(),
  Routes.bmi: (_) => const BmiScreen(),
  Routes.profile: (_) => const ProfileScreen(),
  Routes.allergies: (_) => const AllergiesScreen(),
  Routes.medicine: (_) => const MedicineScreen(),
  Routes.foods: (_) => const FoodsScreen(),
  Routes.adminDashboard: (_) => const AdminDashboardScreen(),
};
