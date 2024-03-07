import 'package:cloud_firestore/cloud_firestore.dart';

class Propiedad {
  String id;
  String titulo;
  String descripcion;
  String tipo;
  double precio;
  Map<String, dynamic> direccion;
  Map<String, dynamic> servicios;
  String fotoPrincipal;
  List<String> fotos;
  List<Map<String, dynamic>> comentarios;
  Map<String, dynamic> disponibilidad;
  String propietario;
  DateTime fechaCreacion;
  DateTime ultimaActualizacion;
  Map<String, dynamic> coordenadas; // Campo nuevo para coordenadas
  String telefono;

  Propiedad({
    this.id = '',
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.precio,
    required this.direccion,
    required this.servicios,
    required this.fotoPrincipal,
    required this.fotos,
    required this.comentarios,
    required this.disponibilidad,
    required this.propietario,
    required this.fechaCreacion,
    required this.ultimaActualizacion,
    required this.coordenadas,
    required this.telefono,
  });

  // Convertir un documento de Firestore en un objeto Propiedad
  factory Propiedad.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Propiedad(
      id: doc.id,
      titulo: data['titulo'],
      descripcion: data['descripcion'],
      tipo: data['tipo'],
      precio: data['precio'],
      direccion: data['direccion'],
      servicios: data['servicios'],
      fotoPrincipal: data['fotoPrincipal'],
      fotos: List<String>.from(data['fotos']),
      comentarios: List<Map<String, dynamic>>.from(data['comentarios']),
      disponibilidad: data['disponibilidad'],
      propietario: data['propietario'],
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      ultimaActualizacion: (data['ultimaActualizacion'] as Timestamp).toDate(),
      coordenadas: data['coordenadas'],
      telefono: data['telefono'],
    );
  }

  // Convertir un objeto Propiedad en un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'precio': precio,
      'direccion': direccion,
      'servicios': servicios,
      'fotoPrincipal': fotoPrincipal,
      'fotos': fotos,
      'comentarios': comentarios,
      'disponibilidad': disponibilidad,
      'propietario': propietario,
      'fechaCreacion': fechaCreacion,
      'ultimaActualizacion': ultimaActualizacion,
      'coordenadas': coordenadas, // Incluir coordenadas al guardar
      'telefono': telefono,
    };
  }
}
