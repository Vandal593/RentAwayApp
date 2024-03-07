import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Necesario para codificar la contraseña en UTF-8
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart'; // Importa la biblioteca crypto para encriptar la contraseña

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> registerUser(
      String username, String email, String password, String rol) async {
    try {
      // Encriptar la contraseña utilizando SHA-256
      var bytes = utf8.encode(password); // Codifica la contraseña en UTF-8
      var digest =
          sha256.convert(bytes); // Realiza el hash SHA-256 de la contraseña

      // Guardar el usuario en Firestore con la contraseña encriptada
      await users.add({
        'username': username,
        'email': email,
        'password': digest.toString(), // Almacena el hash de la contraseña
        'rol': rol,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
      }
      rethrow;
    }
  }
}
