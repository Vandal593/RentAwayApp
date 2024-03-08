// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentawayapp/models/comentario.dart';
import 'package:rentawayapp/models/propiedad.dart';

class PropiedadServices {
  final CollectionReference _propiedadesRef =
      FirebaseFirestore.instance.collection('propiedades');

  // Crear una nueva propiedad
  Future<void> crearPropiedad(Propiedad propiedad) async {
    try {
      await _propiedadesRef.add(propiedad.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  // Leer una propiedad por ID y convertirla a una instancia de Propiedad
  Future<Propiedad> leerPropiedad(String id) async {
    try {
      DocumentSnapshot doc = await _propiedadesRef.doc(id).get();
      return Propiedad.fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }

  // Leer propiedades por propietario y convertirlas a instancias de Propiedad
  Stream<List<Propiedad>> leerPropiedadesPorPropietario(String propietario) {
    return _propiedadesRef
        .where('propietario', isEqualTo: propietario)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Propiedad.fromFirestore(doc)).toList());
  }

  // Actualizar una propiedad existente
  Future<void> actualizarPropiedad(String id, Propiedad propiedad) async {
    try {
      await _propiedadesRef.doc(id).update(propiedad.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar una propiedad
  Future<void> eliminarPropiedad(String id) async {
    try {
      await _propiedadesRef.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Leer todas las propiedades y convertirlas a una lista de instancias de Propiedad
  Stream<List<Propiedad>> leerTodasLasPropiedades() {
    return _propiedadesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Propiedad.fromFirestore(doc)).toList());
  }

  // Ejemplo adicional: Leer propiedades por tipo y convertirlas a instancias de Propiedad
  Stream<List<Propiedad>> leerPropiedadesPorTipo(String tipo) {
    return _propiedadesRef.where('tipo', isEqualTo: tipo).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Propiedad.fromFirestore(doc)).toList());
  }

  Future<void> agregarComentarioAPropiedad(
      String propiedadId, Comentario comentario) async {
    DocumentReference propiedadRef = _propiedadesRef.doc(propiedadId);
    Map<String, dynamic> comentarioMap = comentario.toMap();

    await propiedadRef.update({
      'comentarios': FieldValue.arrayUnion([comentarioMap]),
    });
  }
}
