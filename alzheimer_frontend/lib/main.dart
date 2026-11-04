import 'package:alzheimer_frontend/presentation/screens/welcome/welcome_scren.dart';
import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WelcomeScreen()
        ),
    );
  }
}
