import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController=TextEditingController();
    final emailController=TextEditingController();
    final passwordController=TextEditingController();
    final passwordConfirmController=TextEditingController();
    final phoneController=TextEditingController();
    

    final authProvider=Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Crear cuenta")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electronico',
                prefixIcon: Icon(Icons.email),
              )
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contrasena',
                prefixIcon: Icon(Icons.password)
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: passwordConfirmController,
              decoration: InputDecoration(
                labelText: 'Contrasena confirmacion',
                prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Numero de telefono',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 32,),
            authProvider.isLoading ? const CircularProgressIndicator() 
            : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if(nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty                   
                   ) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Porfavor rellena los campos"))
                    );
                    return;
                   }
                   if(passwordController.text.trim()!= passwordConfirmController.text.trim()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contrasenas no coinciden")));
                    return;
                   }
                   final succes=await context.read<AuthProvider>().registerUser(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    passwordConfirmation: passwordConfirmController.text.trim(),
                    phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(), 
                   );
                   if(context.mounted) {
                    if(succes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registrado con exito "),backgroundColor: Colors.green,)
                        
                      );

                    } else  {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error en el registro"),backgroundColor: Colors.red,));
                      print(context);
                    }
                   }
                },
                child: Text("Registrarse")
              )
            )
          ],
        )
      )
    );
  }
  
}

