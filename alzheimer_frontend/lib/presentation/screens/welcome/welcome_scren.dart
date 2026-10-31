import 'package:alzheimer_frontend/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3F4F6),
              Color.fromARGB(255, 231, 197, 240),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical:20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset("assets/imgs/logo.png",width: 250,height: 250,),
                    Image.asset("assets/imgs/cuidador-paciente.png"),
                    
                    const SizedBox(height: 60,),
                    const Text(
                      "¡Bienvenido!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cuidar de quien olvida también merece ser cuidado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute<void> (
                            builder: (context) => LoginScreen(),
                          ));
                        },
                        icon: Icon(Icons.person,size:30),
                        label: Text("Iniciar Sesion",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 195, 109, 253),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Navegación a Registro con el navigator
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color.fromARGB(255, 195, 109, 253), width: 2),
                          foregroundColor: const Color.fromARGB(255, 195, 109, 253),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.rocket_launch,size: 30,),
                        label: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 22,color: Color.fromARGB(255,195,109,253), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), 
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
