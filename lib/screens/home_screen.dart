import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/screens/detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rent Away App",
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.shade400,
              Colors.white, // Color más claro en la parte superior
              // Color más oscuro en la parte inferior
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore.collection('propiedades').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Propiedad propiedad =
                    Propiedad.fromFirestore(snapshot.data!.docs[index]);
                return _buildPropiedadCard(propiedad, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPropiedadCard(Propiedad propiedad, BuildContext context) {
    // URL de la imagen predeterminada
    String imagenPredeterminada =
        'https://icons-for-free.com/iff/png/512/default+home+house+main+menu+icon-1320086046804091155.png';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // This will stretch the row's children to fill the card vertically.
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                propiedad.fotoPrincipal.isNotEmpty
                    ? propiedad.fotoPrincipal
                    : imagenPredeterminada,
                width: 100, // Ancho más grande para la imagen
                height: 100, // Altura fija
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10), // Padding for top and bottom
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrado vertical
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propiedad.titulo,
                      style: const TextStyle(
                        fontSize: 20, // Texto más grande para el título
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Precio: ${propiedad.precio}',
                      style: const TextStyle(
                        fontSize: 18, // Texto más grande para el precio
                        color: Colors.grey, // Color gris para el precio
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detalle: ${propiedad.descripcion}',
                      style: const TextStyle(
                        fontSize: 16, // Texto adecuado para el detalle
                        color: Colors.black54, // Color para los detalles
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3, // Muestra hasta tres líneas del detalle
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalleScreen(propiedad: propiedad),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.blue.shade400, // Color del texto del botón
                  ),
                  child: const Text(
                    'Ver',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
