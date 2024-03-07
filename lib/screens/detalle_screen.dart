import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:rentawayapp/screens/comentario_screen.dart';
import 'package:rentawayapp/screens/login_screen.dart';
import 'package:rentawayapp/screens/ubicacion_screen.dart';
import 'package:rentawayapp/services/userState.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleScreen extends StatelessWidget {
  final Propiedad propiedad;

  const DetalleScreen({super.key, required this.propiedad});

  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);

    String imagenPredeterminada =
        'https://icons-for-free.com/iff/png/512/default+home+house+main+menu+icon-1320086046804091155.png';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          propiedad.titulo.toString(),
          style: const TextStyle(
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Contenido de tu pantalla
                  Expanded(
                    child: Column(
                      children: [
                        // Tus widgets van aquí dentro
                        SizedBox(
                          height: 150,
                          child: propiedad.fotos
                                  .isNotEmpty // Verifica si la lista de fotos no está vacía
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: propiedad.fotos.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      propiedad.fotos[index],
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // En caso de error al cargar la imagen, muestra una imagen predeterminada.
                                        return Image.network(
                                          imagenPredeterminada, // Ruta a una imagen local predeterminada
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: Image.network(
                                    imagenPredeterminada, // Muestra una imagen predeterminada si la lista está vacía
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // Continúa con el resto de tu widget Column aquí
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSection(
                                  "Descripción", propiedad.descripcion),
                              _buildSection("Servicios", propiedad.servicios),
                              _buildSection(
                                  "Dirección", propiedad.direccion['calle']),
                              _buildSection(
                                  "Calificación",
                                  RatingBarIndicator(
                                    rating:
                                        2, // Asegúrate de convertir calificacion a double
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  )),
                              const Divider(),
                              ElevatedButton(
                                onPressed: () {
                                  // Verifica el estado del usuario aquí
                                  if (userState.userId != '') {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => ComentarioScreen(
                                            propiedad: propiedad),
                                      ),
                                    )
                                        .then((value) {
                                      // Opcionalmente, recarga los comentarios si es necesario
                                    });
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  }
                                },
                                child: const Text('Agregar Comentario'),
                              ),
                              _buildCommentsSection(context),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _styledButton(
                                    context,
                                    'Contactar',
                                    () => reachUs(context),
                                  ),
                                  _styledButton(
                                    context,
                                    'Ubicación',
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UbicacionScreen(
                                              propiedad: propiedad)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    Widget contentWidget;

    if (content is String) {
      // Contenido es un texto
      contentWidget = Text(content);
    } else if (content is Map) {
      // Contenido es un mapa, específicamente para "Servicios"
      var serviciosList = content.entries
          .where((servicio) => servicio.value as bool)
          .map((servicio) => "• ${servicio.key}")
          .toList();

      contentWidget = serviciosList.isEmpty
          ? const Text("No hay servicios disponibles")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  serviciosList.map((servicio) => Text(servicio)).toList(),
            );
    } else if (content is Widget) {
      // Contenido es un widget, directamente renderizar el widget
      contentWidget = content;
    } else {
      // Manejo por defecto
      contentWidget = const Text('Tipo de contenido no soportado');
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            contentWidget, // Renderiza el contenido basado en el tipo
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    if (propiedad.comentarios.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No hay comentarios"),
      );
    } else {
      return Column(
        children: propiedad.comentarios
            .map((comentario) => ListTile(
                  title: Text(comentario['username']),
                  subtitle: Text(comentario['comentario']),
                  trailing: RatingBarIndicator(
                    rating: comentario['calificacion'].toDouble(),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ))
            .toList(),
      );
    }
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

  Future<void> reachUs(BuildContext context) async {
    var phone = propiedad.telefono; // Asegúrate de que el formato sea correcto.
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent('Hola, necesito ayuda')}");

    if (!await launchUrl(whatsappUri)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No se pudo abrir WhatsApp. Por favor, verifica si está instalado.'),
        ),
      );
    }
  }
}
