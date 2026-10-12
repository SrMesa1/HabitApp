/// Modelo central de la app: un hábito que la persona quiere cumplir.
class Habito {
  /// Categorías disponibles (constante: no cambia mientras corre la app).
  static const List<String> categorias = [
    'Estudio',
    'Salud',
    'Personal',
    'Trabajo',
  ];

  final String id;
  final String nombre;
  final String categoria;
  final DateTime creadoEn;
  bool completado;

  DateTime? completadoEn;

  Habito({
    required this.id,
    required this.nombre,
    required this.categoria,
    DateTime? creadoEn,
    this.completado = false,
    this.completadoEn,
  }) : creadoEn = creadoEn ?? DateTime.now();

  void alternar() {
    completado = !completado;
    completadoEn = completado ? DateTime.now() : null;
  }

  String get etiquetaEstado => completado ? 'Completado' : 'Pendiente';

  Map<String, dynamic> aJson() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'creadoEn': creadoEn.toIso8601String(),
        'completado': completado,
        'completadoEn': completadoEn?.toIso8601String(),
      };

  factory Habito.desdeJson(Map<String, dynamic> json) {
    final textoCompletado = json['completadoEn'] as String?;
    return Habito(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      categoria: json['categoria'] as String,
      creadoEn: DateTime.tryParse(json['creadoEn'] as String? ?? ''),
      completado: json['completado'] as bool? ?? false,
      completadoEn: textoCompletado == null
          ? null
          : DateTime.tryParse(textoCompletado),
    );
  }
}
