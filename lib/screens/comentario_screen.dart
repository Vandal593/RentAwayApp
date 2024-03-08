// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/models/comentario.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/services/propiedadServices.dart';
import 'package:rentawayapp/services/userState.dart';

class ComentarioScreen extends StatefulWidget {
  final Propiedad propiedad;
  const ComentarioScreen({super.key, required this.propiedad});

  @override
  State<ComentarioScreen> createState() => _ComentarioScreen();
}

class _ComentarioScreen extends State<ComentarioScreen> {
  double _rating = 0;
  final TextEditingController _comentarioController = TextEditingController();
  final PropiedadServices propiedadServices = PropiedadServices();

  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Comentario'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Califica esta propiedad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Escribe tu comentario:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _comentarioController,
              decoration: const InputDecoration(
                hintText: "Comentario",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _enviarComentario(userState.userId.toString()),
                child: const Text('Enviar Comentario'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enviarComentario(String name) async {
    String texto = _comentarioController.text;
    double calificacion = _rating;

    Comentario nuevoComentario = Comentario(
      username: name,
      comentario: texto,
      calificacion: calificacion,
    );

    try {
      await PropiedadServices()
          .agregarComentarioAPropiedad(widget.propiedad.id, nuevoComentario);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario añadido con éxito')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir comentario: $e')));
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }
}
