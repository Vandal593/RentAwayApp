import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/firebase_options.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/screens/comentario_screen.dart';
import 'package:rentawayapp/screens/home_screen.dart';
import 'package:rentawayapp/screens/login_screen.dart';
import 'package:rentawayapp/screens/principal_screen.dart';
import 'package:rentawayapp/services/userState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.blue,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        title: 'Rent Away App',
        routes: {
          '/': (_) => const PrincipalScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/comentarioScreen') {
            final Propiedad propiedad = settings.arguments as Propiedad;
            return MaterialPageRoute(builder: (context) {
              return ComentarioScreen(propiedad: propiedad);
            });
          }
          // Define otras rutas dinámicas aquí
          return null; // Implementación de manejo de rutas no definidas
        },
        initialRoute: '/',
      ),
    );
  }
}
