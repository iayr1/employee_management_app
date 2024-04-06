import 'package:employee_management_app/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EmployeeManagementApp());
}

class EmployeeManagementApp extends StatelessWidget {
  const EmployeeManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}