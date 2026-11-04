import 'package:alzheimer_frontend/home/home_screen.dart';
import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _nameController=TextEditingController();
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final _confirmController=TextEditingController();
  final _phoneController=TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final authProvider=Provider.of<AuthProvider>(context);
      final size= MediaQuery.of(context).size;

      return Scaffold(
        body: Stack(
          children: [
            _BubbleBackground(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Column(
                 children: [
                  SizedBox(height: size.height*0.05),
                  _HeaderTitle(),
                  SizedBox(height: size.height*0.05,),

                  _CustomTextField(
                    controller: _nameController,
                    label: "Nombre completo",
                    icon: Icons.person
                  ),
                  _CustomTextField(
                    controller: _emailController,
                    label: "Correo electronico",
                    icon: Icons.email,
                  ),
                  _CustomTextField(
                    controller: _passwordController,
                    label: "Contraseña",
                    icon: Icons.password
                  ),
                  _CustomTextField(
                    controller:  _confirmController,
                    label: "Confirmacion de contraseña",
                    icon: Icons.password
                  ),
                  _CustomTextField(
                    controller: _phoneController,
                    label: "Numero de telefono",
                    icon: Icons.phone
                  ),
                  authProvider.isLoading ? const CircularProgressIndicator(color: Colors.purple)
                  : _SubmitButton(onPressed: _listenRegister)
                 ],
                )
            ))
          ],
        )
      );
  }
  void _listenRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfirm = _confirmController.text.trim();
    final phone= _phoneController.text.trim();

     void _showSnackBar(String message,{bool isError= true}) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: isError? Colors.redAccent : Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
       }

    if(name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar("Porfavor, rellena los campos obligatorios");
      return;
    }
    if(password != passwordConfirm) {
      _showSnackBar("Las contrasenas deben de coincidir");
      return;
    }
    final success= await context.read<AuthProvider>().registerUser(
      name: name,
     email: email,
      password: password,
       passwordConfirmation: passwordConfirm);
       if(!mounted) return;
       if(success) {
        _showSnackBar("Registrado con exito!",isError: false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
       } else {
        _showSnackBar("Error en el registro");
       }
      
  }
}


class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SubmitButton({required this.onPressed});

  @override

  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[400],foregroundColor: Colors.white, elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
      ),onPressed: onPressed, child: Text("Registrarse",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)) )
    );
  }
}
class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Crear cuenta",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.purple[800])),
        const SizedBox(height: 8,),
        Text("Registrarse para comenzar",style: TextStyle(
          fontSize: 16,color: Colors.black54
        ))

      ],
    );
  }
}
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;


  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText=false,
    this.keyboardType= TextInputType.text,
    });

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon,color: Colors.purple[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 16)
        )
      ),
    );
  }
} 

class  _BubbleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFFF3F4F6), Color.fromARGB(255, 231, 197, 240)
              ]
            )
          )
        ),
        const _PositionedBubble(top: -50, left: -50, size: 180),
        const _PositionedBubble(top: 200, right: -60, size: 140),
        const _PositionedBubble(bottom: -40, left: 30, size: 120),
        const _PositionedBubble(bottom: 150, left: -40, size: 90),
      ],
    );
  }
}
class _PositionedBubble extends StatelessWidget {
  final double? top,bottom,left,right;
  final double size;

  const _PositionedBubble({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.35)
        )
      )
    );
  }
}