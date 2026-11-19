import 'package:wry_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaregiverDashboardScreen extends StatefulWidget {
  const CaregiverDashboardScreen({super.key});
 
 @override
  State<CaregiverDashboardScreen> createState() => _CaregiverDashBoardScreen();


}
  class _CaregiverDashBoardScreen extends State<CaregiverDashboardScreen> {
      int _currentIndex=0;
  @override
  Widget build(BuildContext context) {

  final List<Widget> _pages= [
    const Center(child: Text("Pantalla de Inicio",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantalla de Consulta",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantalla de Pacientes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
    const Center(child: Text("Pantallad de Perfil", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)))
  ];
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paciente'),
        backgroundColor: Colors.purple[400],
        foregroundColor: Colors.white,
      ),
      body:  _pages[_currentIndex],
      bottomNavigationBar:  NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
          _currentIndex=index;  
          });
        },
        destinations: [ 
          NavigationDestination(icon: Icon(Icons.home), label: "Inicio"),
          NavigationDestination(icon: Icon(Icons.chat), label: "Consulta"),
          NavigationDestination(icon: Icon(Icons.manage_accounts), label: "Pacientes"),
          NavigationDestination(icon: Icon(Icons.person), label: "Perfil")
        ],
      ),
    );
  }
}

