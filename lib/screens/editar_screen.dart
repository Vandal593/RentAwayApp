import 'package:flutter/material.dart';
import 'package:rentawayapp/models/propiedad.dart';

class EditarScreen extends StatefulWidget {
  final Propiedad propiedad;
  const EditarScreen({super.key, required this.propiedad});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color de la flecha de regreso a blanco
        ),
      ),
      body: Container(),
    );
  }
}
