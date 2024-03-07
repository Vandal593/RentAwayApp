import 'package:flutter/material.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/screens/detalle_screen.dart';
import 'package:rentawayapp/screens/registerPropiedad.dart';
import 'package:rentawayapp/services/propiedadServices.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Utilizando PropiedadServices para filtrar propiedades por el ID del propietario actual
    Stream<List<Propiedad>> propiedadesDelPropietarioStream =
        PropiedadServices().leerPropiedadesPorPropietario(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 189, 226, 243),
      body: StreamBuilder<List<Propiedad>>(
        stream: propiedadesDelPropietarioStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var propiedades = snapshot.data!;
          if (propiedades.isEmpty) {
            return const Center(child: Text('No hay propiedades disponibles'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: propiedades.length,
            itemBuilder: (context, index) {
              Propiedad propiedad = propiedades[index];
              return _buildPropiedadCard(propiedad, context);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const RegistroPropiedadScreen()), // Asegúrate de cambiar esto por el constructor de tu nueva pantalla
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add), // Puedes cambiar el color según tu diseño
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
                  child: const Text('Ver'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
