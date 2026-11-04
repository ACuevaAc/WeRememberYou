import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser= authProvider.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Text("Correo: ${currentUser?.email}"),
          Text("ROL: ${currentUser?.role}")
        ],
      )
    );
  }
}