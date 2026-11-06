import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreen();

}

class _homeScreen extends State<HomeScreen> {


 
      int _currentIndex=0;
      final List<Widget> _pages=  [ 
        const Center(child: Text("Pantalla de Inicio",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
        const Center(child: Text("Pantalla de Consulta",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
        const Center(child: Text("Pantalla de Pacientes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
        const Center(child: Text("Pantalla de Perfil",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),

      ];

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("We Remem"),
            backgroundColor: Colors.purple,
            ),
          body: _pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex=index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home),
                 label: "Inicio"
                 ),
              NavigationDestination(
                icon: Icon(Icons.chat),
                label: "Consulta"),
              NavigationDestination(
                icon: Icon(Icons.manage_accounts),
                label: "Pacientes",
                ),
              NavigationDestination(
                icon: Icon(Icons.person),
                 label: "Perfil"
                 )
            ],
          ),
        );

      }
    
}