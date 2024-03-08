// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/screens/dashboard.dart';
import 'package:rentawayapp/screens/home_screen.dart';
import 'package:rentawayapp/screens/register_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:rentawayapp/services/userState.dart';

class LoginScreen extends StatelessWidget {
  final String? redirectAfterLogin;
  final Propiedad? propiedad;
  LoginScreen({super.key, this.redirectAfterLogin, this.propiedad});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajaAzul(size),
            iconoPersona(),
            loginForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Login', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 30),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          hintText: 'ejemplo@hotmail.com',
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          hintText: '**********',
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .blue.shade900; // Color cuando se presiona
                              }
                              return Colors.blue.shade600; // Color por defecto
                            },
                          ),
                          shadowColor:
                              MaterialStateProperty.all(Colors.blue.shade900),
                          elevation: MaterialStateProperty.resolveWith<double>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return 5; // Menor elevación cuando se presiona
                              }
                              return 10; // Elevación por defecto
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                        ),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          _loginUser(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              // Navegar a la pantalla de registro cuando se toca el texto
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                          redirectAfterLogin:
                              redirectAfterLogin, // Asume que tienes rutas nombradas configuradas
                          propiedad: propiedad,
                        )),
              );
            },
            child: const Text(
              'Crea una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      // Encriptar la contraseña ingresada por el usuario
      var bytes = utf8.encode(password);
      var digest = sha256.convert(bytes);

      // Obtener los datos del usuario desde Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Verificar si se encontró un usuario con el correo electrónico proporcionado
      if (snapshot.docs.isNotEmpty) {
        // Obtener la contraseña almacenada en Firestore
        String storedPassword = snapshot.docs.first.data()['password'];
        String role = snapshot.docs.first
            .data()['rol']; // Asumiendo que el campo se llama 'role'
        String username = snapshot.docs.first.data()['username'] as String;
        Provider.of<UserState>(context, listen: false).login(username, role);
        // Comparar las contraseñas encriptadas
        if (storedPassword == digest.toString()) {
          // Autenticación exitosa, navegar a la pantalla correspondiente basada en el rol
          if (redirectAfterLogin != null) {
            Navigator.of(context).pushReplacementNamed(redirectAfterLogin!,
                arguments: propiedad); // Asume uso de rutas nombradas
            return;
          } else {
            if (role == 'Inquilino') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (role == 'Arrendatario') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(userId: username)),
              );
            }
            return;
          }
        }
      }

      // Las credenciales son incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas. Inténtalo de nuevo.'),
        ),
      );
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante el inicio de sesión
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se produjo un error durante el inicio de sesión.'),
        ),
      );
    }
  }

  SafeArea iconoPersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container cajaAzul(Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue,
            Colors.blue,
          ],
        ),
      ),
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Positioned(
            top: 90,
            left: 30,
            child: burbuja(),
          ),
          Positioned(
            top: -40,
            left: -30,
            child: burbuja(),
          ),
          Positioned(
            top: -50,
            right: -20,
            child: burbuja(),
          ),
          Positioned(
            top: -50,
            left: 10,
            child: burbuja(),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: burbuja(),
          ),
        ],
      ),
    );
  }

  Container burbuja() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
