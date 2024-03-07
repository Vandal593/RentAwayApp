import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/screens/home_screen.dart';
import 'package:rentawayapp/screens/login_screen.dart';
import 'package:rentawayapp/services/userState.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white, // Color más claro en la parte superior
              Colors.blue.shade400, // Color más oscuro en la parte inferior
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                  'assets/images/LogoRentAway.png'), // Asumiendo que el logo es azul.
              const SizedBox(height: 30),
              const Text(
                '¿Quién eres?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _styledButton(
                    context,
                    'Soy Inquilino',
                    () {
                      Provider.of<UserState>(context, listen: false)
                          .login('', 'Inquilino');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _styledButton(
                    context,
                    'Soy Arrendador',
                    () {
                      Provider.of<UserState>(context, listen: false)
                          .login('', 'Arrendatario');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _styledButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue.shade900; // Color cuando se presiona
            }
            return Colors.blue.shade600; // Color por defecto
          },
        ),
        shadowColor: MaterialStateProperty.all(Colors.blue.shade900),
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return 5; // Menor elevación cuando se presiona
            }
            return 10; // Elevación por defecto
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
