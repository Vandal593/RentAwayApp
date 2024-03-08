class Comentario {
  String username;
  String comentario;
  double calificacion;

  Comentario({
    required this.username,
    required this.comentario,
    required this.calificacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'comentario': comentario,
      'calificacion': calificacion,
    };
  }

  static Comentario fromMap(Map<String, dynamic> map) {
    return Comentario(
      username: map['usuario'],
      comentario: map['texto'],
      calificacion: map['calificacion'],
    );
  }
}
