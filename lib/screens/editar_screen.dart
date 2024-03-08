import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentawayapp/models/propiedad.dart';

class EditarScreen extends StatefulWidget {
  final Propiedad propiedad;
  const EditarScreen({super.key, required this.propiedad});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imagePrincipal;
  // Lista para manejar URLs de imágenes existentes (de la base de datos)
  List<String> _imagenesExistentes = [];

  // Lista para manejar archivos de nuevas imágenes seleccionadas (aún no guardadas)
  List<XFile> _nuevasImagenesSeleccionadas = [];

  final _formKey = GlobalKey<FormState>();

  late TextEditingController tituloController;
  late TextEditingController descripcionController;
  late TextEditingController tipoController;
  late TextEditingController precioController;
  late TextEditingController calleController;
  late TextEditingController ciudadController;
  late TextEditingController paisController;
  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late TextEditingController telefonoController;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales de la propiedad
    tituloController = TextEditingController(text: widget.propiedad.titulo);
    descripcionController =
        TextEditingController(text: widget.propiedad.descripcion);
    tipoController = TextEditingController(text: widget.propiedad.tipo);
    precioController =
        TextEditingController(text: widget.propiedad.precio.toString());
    calleController = TextEditingController(
        text: widget.propiedad.direccion['calle'].toString());
    ciudadController = TextEditingController(
        text: widget.propiedad.direccion['ciudad'].toString());
    paisController = TextEditingController(
        text: widget.propiedad.direccion['pais'].toString());
    latitudController = TextEditingController(
        text: widget.propiedad.coordenadas['lat'].toString());
    longitudController = TextEditingController(
        text: widget.propiedad.coordenadas['lng'].toString());
    telefonoController =
        TextEditingController(text: widget.propiedad.telefono.toString());
    _imagenesExistentes = List.from(widget.propiedad.fotos);
    // Continúa con el resto de los campos
  }

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    tipoController.dispose();
    precioController.dispose();
    calleController.dispose();
    ciudadController.dispose();
    paisController.dispose();
    latitudController.dispose();
    longitudController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  // Widget para mostrar imágenes existentes...
  Widget _buildImagenesExistentes() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _imagenesExistentes.map((url) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  _imagenesExistentes.remove(url);
                  // Actualizar la lista de imágenes en la base de datos según sea necesario
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  // Widget para mostrar nuevas imágenes seleccionadas...
  Widget _buildNuevasImagenesSeleccionadas() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _nuevasImagenesSeleccionadas.map((file) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(File(file.path),
                width: 100, height: 100, fit: BoxFit.cover),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  _nuevasImagenesSeleccionadas.remove(file);
                  // No necesitas actualizar la base de datos aquí ya que son imágenes aún no guardadas
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _pickImagePrincipal() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        // Esta es una nueva imagen seleccionada, manejarla adecuadamente
        _imagePrincipal = selectedImage;
        // Considera actualizar el estado de la imagen principal en la base de datos o preparar para guardar
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        // Agregar nuevas imágenes seleccionadas a la lista de nuevas imágenes
        _nuevasImagenesSeleccionadas.addAll(selectedImages);
      });
    }
  }

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: tituloController,
                            decoration: InputDecoration(
                              labelText: 'Título',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.title), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un título';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: descripcionController,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.description), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una descripción';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: tipoController,
                            decoration: InputDecoration(
                              labelText: 'Tipo de Propiedad',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.holiday_village), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el tipo de propiedad';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: precioController,
                            decoration: InputDecoration(
                              labelText: 'Precio',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.monetization_on), // Icono de ejemplo
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el precio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: calleController,
                            decoration: InputDecoration(
                              labelText: 'Calle',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.directions), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la calle';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: ciudadController,
                            decoration: InputDecoration(
                              labelText: 'Ciudad',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.location_city), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la ciudad';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: paisController,
                            decoration: InputDecoration(
                              labelText: 'País',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.flag), // Icono de ejemplo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el país';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: latitudController,
                            decoration: InputDecoration(
                              labelText: 'Latitud',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.location_searching), // Icono de ejemplo
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la latitud';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: longitudController,
                            decoration: InputDecoration(
                              labelText: 'Longitud',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                  Icons.location_searching), // Icono de ejemplo
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la longitud';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: telefonoController,
                            decoration: InputDecoration(
                              labelText: 'Teléfono',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.call), // Icono de ejemplo
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el telefono';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _styledButton(
                            context,
                            'Seleccionar Imagen Principal',
                            _pickImagePrincipal,
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 20),
                          _buildImagenesExistentes(),
                          _styledButton(
                            context,
                            'Seleccionar Imágenes',
                            _pickImages,
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 20),
                          Builder(
                            builder: (context) => _styledButton(
                              context,
                              'Registrar Propiedad',
                              () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
              return 2; // Menor elevación cuando se presiona
            }
            return 5; // Elevación por defecto
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
