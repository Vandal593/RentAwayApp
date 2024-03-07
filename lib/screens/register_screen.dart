// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/screens/dashboard.dart';
import 'package:rentawayapp/screens/home_screen.dart';
import 'package:rentawayapp/screens/login_screen.dart';
import 'package:rentawayapp/services/firestore.dart';
import 'package:rentawayapp/services/userState.dart'; // Importa tu servicio Firestore

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
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
            cajaPurpura(size),
            iconoPersona(),
            registerForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView registerForm(BuildContext context) {
    var userState = Provider.of<UserState>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 150),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 450,
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
                Text('Registrarse',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 30),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_2_rounded),
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      Text('Te estas registrando como: ${userState.userRole}'),
                      const SizedBox(height: 20),
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
                          'Registrarse',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          _registerUser(context, userState.userRole.toString());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Ya tengo una cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerUser(BuildContext context, String rol) async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Verificar si todos los campos del formulario están llenos
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Llamar al servicio de Firestore para registrar el usuario
        await FirestoreService().registerUser(name, email, password, rol);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
        );

        // Autenticación exitosa, navegar a la pantalla correspondiente basada en el rol
        if (rol == 'Inquilino') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (rol == 'Arrendatario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(userId: name)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    } else {
      // Si algún campo está vacío, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
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

  Container cajaPurpura(Size size) {
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
