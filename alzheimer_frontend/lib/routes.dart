import 'package:alzheimer_frontend/presentation/screens/dashboard/admin_dashboard_screen.dart';
import 'package:alzheimer_frontend/presentation/screens/dashboard/caregiver_dashboard_screen.dart';
import 'package:alzheimer_frontend/presentation/screens/dashboard/patient_dashboard_screen.dart';
import 'package:alzheimer_frontend/presentation/screens/welcome/welcome_scren.dart';
import 'package:flutter/material.dart';

Widget homeForRole(String? role) {
  switch (role) {
    case 'a':
      return const AdminDashboardScreen();
    case 'u':
      return CaregiverDashboardScreen();
    case 'p':
      return const PatientDashboardScreen();
    default:
      return const WelcomeScreen();
  }
}
