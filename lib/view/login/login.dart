import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movil_inspeccion/service/loginService.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/utils/sesion.dart';
import 'package:movil_inspeccion/view/menu/menuPrincipal.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = await Loginservice.login(
        _emailController.text.trim(), _passwordController.text.trim());
     

    if (result["success"]) {
      try {
        final int userId = result["id"];
        ASession.setUserid(userId);
        if(!mounted) return;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Menuprincipal()));
      } catch (e) {
        debugPrint(e.toString());
        if (mounted) setState(() => _loading = false);
      }
    } else {
      setState(() {
        _loading = false;
        _errorMessage = result["message"];
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 24, 45),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/banner.png'),
                  fit: BoxFit.none, 
                  scale: 0.9, // Ajusta este valor (menor a 1 es zoom in, mayor a 1 es zoom out)
                  alignment: Alignment(-0.0, 1.0),
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(153, 27, 38, 65),  
                    BlendMode.darken,
                  ))),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/logoOPV.jpeg',
                    width: size.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY:10 ),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Inspect',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                             
                            const SizedBox(height: 10),
                            const Text(
                              "Registra tus avances en segundos y mantén tu gestión clara.",
                              // 'Sistema de Inspección SST\npara la Industria Metalmecánica',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color.fromARGB(171, 255, 255, 255), fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 30),

                            // Input Usuario
                            _buildTextField(
                              controller: _emailController,
                              hint: 'Usuario',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 15),
                            
                            // Input Contraseña
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'Contraseña',
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: COLORFONDO, // Rojo industrial
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  elevation: 0,
                                ),
                                onPressed: _loading ? null : _login,
                                child: _loading 
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('INICIAR SESIÓN', 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      ),
                  )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool isPassword = false
}){
  return TextField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(color: Colors.black87),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle:const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color:COLORFONDO),
 
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ), 
    ),
  );
}
