import 'package:alzheimer_frontend/presentation/screens/admin/manage_user.dart';
import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:alzheimer_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreen();

  }

class _AdminDashboardScreen extends State<AdminDashboardScreen> {

  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages= [
      Center(child: Text("RAG",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
      Center(child: Text("No se ahora",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
      ManageUserScreen()
    ];
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        backgroundColor: Colors.purple[400],
        foregroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) async {
          if(index==2) {
            final token= context.read<AuthProvider>().token!;
            await context.read<UserProvider>().fetchUsers(token);
          }
          if(!mounted) return;
          setState(() {
            _currentIndex=index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.chat), label: "RAG"),
          NavigationDestination(icon: Icon(Icons.dangerous), label: "Nose"),
          NavigationDestination(icon: Icon(Icons.person_search), label: "Usuarios")
        ]),
    );
  }
  }

