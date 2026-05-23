class Juego {
  final String titulo;
  final String descripcion;
  final String tipo;
  final String nivel;
  final String? imagen;

  Juego({
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.nivel,
    this.imagen,
  });

  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
      nivel: json['nivel'],
      imagen: json['imagen'],
    );
  }
}
