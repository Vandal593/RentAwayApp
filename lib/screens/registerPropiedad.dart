// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:rentawayapp/services/propiedadServices.dart';
import 'package:rentawayapp/models/propiedad.dart';
import 'package:path/path.dart' show basename;
import 'package:rentawayapp/services/userState.dart';

class RegistroPropiedadScreen extends StatefulWidget {
  const RegistroPropiedadScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RegistroPropiedadScreenState createState() =>
      _RegistroPropiedadScreenState();
}

class _RegistroPropiedadScreenState extends State<RegistroPropiedadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imagePrincipal;
  List<XFile> _imagenes = [];

  final _formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final tipoController = TextEditingController();
  final precioController = TextEditingController();
  final calleController = TextEditingController();
  final ciudadController = TextEditingController();
  final paisController = TextEditingController();
  final latitudController = TextEditingController();
  final longitudController = TextEditingController();
  final telefonoController = TextEditingController();

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

  void _limpiarCampos() {
    tituloController.clear();
    descripcionController.clear();
    tipoController.clear();
    precioController.clear();
    calleController.clear();
    ciudadController.clear();
    paisController.clear();
    latitudController.clear();
    longitudController.clear();
    telefonoController.clear();
    setState(() {
      _imagePrincipal = null;
      _imagenes.clear();
    });
  }

  Future<void> _pickImagePrincipal() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePrincipal = selectedImage;
    });
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    setState(() {
      _imagenes = selectedImages;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? urlImagenPrincipal;
        if (_imagePrincipal != null) {
          urlImagenPrincipal = await _uploadImage(_imagePrincipal!);
        }

        List<String> urlsImagenes = [];
        for (XFile imagen in _imagenes) {
          String imageUrl = await _uploadImage(imagen);
          urlsImagenes.add(imageUrl);
        }

        final direccion = {
          'calle': calleController.text,
          'ciudad': ciudadController.text,
          'pais': paisController.text,
        };

        final servicios = {'wifi': true};

        final coordenadas = {
          'lat': double.tryParse(latitudController.text) ?? 0.0,
          'lng': double.tryParse(longitudController.text) ?? 0.0,
        };

        String tel = telefonoController.text
            .trim(); // Asegúrate de quitar espacios en blanco al inicio y al final

        // Verifica si el número ya tiene el formato internacional
        if (!tel.startsWith('+593')) {
          // Verifica si el número comienza con '0' y reemplaza el primer '0' con '+593'
          if (tel.startsWith('0')) {
            tel = '+593${tel.substring(1)}';
          } else {
            // Si el número no comienza con '0', simplemente añade '+593' al inicio
            tel = '+593$tel';
          }
        }
        var userState = Provider.of<UserState>(context, listen: false);
        if (kDebugMode) {
          print(userState.userId.toString());
        }
        final nuevaPropiedad = Propiedad(
          titulo: tituloController.text,
          descripcion: descripcionController.text,
          tipo: tipoController.text,
          precio: double.tryParse(precioController.text) ?? 0.0,
          direccion: direccion,
          servicios: servicios,
          fotoPrincipal: urlImagenPrincipal ?? '',
          fotos: urlsImagenes,
          comentarios: [],
          disponibilidad: {'desde': DateTime.now(), 'hasta': DateTime.now()},
          propietario: userState.userId.toString(),
          fechaCreacion: DateTime.now(),
          ultimaActualizacion: DateTime.now(),
          coordenadas: coordenadas,
          telefono: tel,
        );

        await PropiedadServices().crearPropiedad(nuevaPropiedad);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Propiedad registrada con éxito')));

        _limpiarCampos(); // Limpia los campos del formulario
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar la propiedad: $e')));
      }
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      String fileName = basename(image.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('imagenes/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Error al subir imagen: $e");
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Propiedad: ${userState.userId}',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
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
                            decoration:
                                const InputDecoration(labelText: 'Título'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un título';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: descripcionController,
                            decoration:
                                const InputDecoration(labelText: 'Descripción'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una descripción';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: tipoController,
                            decoration: const InputDecoration(
                                labelText: 'Tipo de Propiedad'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el tipo de propiedad';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: precioController,
                            decoration:
                                const InputDecoration(labelText: 'Precio'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el precio';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: calleController,
                            decoration:
                                const InputDecoration(labelText: 'Calle'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la calle';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: ciudadController,
                            decoration:
                                const InputDecoration(labelText: 'Ciudad'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la ciudad';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: paisController,
                            decoration:
                                const InputDecoration(labelText: 'País'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el país';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: latitudController,
                            decoration:
                                const InputDecoration(labelText: 'Latitud'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la latitud';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: longitudController,
                            decoration:
                                const InputDecoration(labelText: 'Longitud'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la longitud';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: telefonoController,
                            decoration:
                                const InputDecoration(labelText: 'Telefono'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el telefono';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: _pickImagePrincipal,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 245, 229,
                                      161)), // Aquí establece el color de fondo del botón
                            ),
                            child: const Text('Seleccionar Imagen Principal'),
                          ),
                          _imagePrincipal != null
                              ? Image.file(File(_imagePrincipal!.path))
                              : const Text(
                                  "No se ha seleccionado imagen principal"),
                          ElevatedButton(
                            onPressed: _pickImages,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 245, 229,
                                      161)), // Aquí establece el color de fondo del botón
                            ),
                            child: const Text('Seleccionar Imágenes'),
                          ),
                          _imagenes.isNotEmpty
                              ? Wrap(
                                  children: _imagenes
                                      .map((img) => Image.file(File(img.path),
                                          width: 100, height: 100))
                                      .toList(),
                                )
                              : const Text(
                                  "No se han seleccionado imágenes adicionales"),
                          Builder(
                            builder: (context) => ElevatedButton(
                              onPressed: _submit,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(const Color.fromARGB(
                                        255,
                                        227,
                                        169,
                                        241)), // Aquí establece el color de fondo del botón
                              ),
                              child: const Text('Registrar Propiedad'),
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
}
