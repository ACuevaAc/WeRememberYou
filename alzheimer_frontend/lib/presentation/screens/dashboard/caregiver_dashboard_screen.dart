import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaregiverDashboardScreen extends StatefulWidget {
  CaregiverDashboardScreen({super.key});
 
 @override
  State<CaregiverDashboardScreen> createState() => _CaregiverDashBoardScreen();


int _currentIndex=0;
  final List<Widget> _pages= [
    const Center(child: Text("Pantalla de Inicio",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantalla de Consulta",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantalla de Pacientes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantallad de Perfil", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)))
  ];
  // Pendiente de seguir dashboard en el body

}
  class _CaregiverDashBoardScreen extends State<CaregiverDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paciente'),
        backgroundColor: Colors.purple[400],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hola, ${user?.name ?? ''}'),
            Text('Rol: ${user?.role ?? ''}'),
            const SizedBox(height: 8),
            const Text('Aquí irán las vistas del paciente.'),
          ],
        ),
      ),
    );
  }
}

