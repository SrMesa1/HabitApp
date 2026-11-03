String formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}

/// Registro de actividad: el tiempo que la persona dedicó a un hábito
/// en un día concreto, con una observación sobre cómo le fue.
class RegistroActividad {
  final String id;
  final String habitoId;
  final String habitoNombre;
  final DateTime fecha;
  final int minutos;
  final String observacion;

  RegistroActividad({
    required this.id,
    required this.habitoId,
    required this.habitoNombre,
    required DateTime fecha,
    required this.minutos,
    required this.observacion,
  }) : fecha = DateTime(fecha.year, fecha.month, fecha.day); // solo el día

  /// Combinación que no se puede repetir: un registro por hábito y por día.
  String get claveUnica =>
      '$habitoId|${fecha.year}-${fecha.month}-${fecha.day}';

  String get fechaTexto => formatearFecha(fecha);

  /// Duración legible: "45 min", "2 h" o "1 h 30 min".
  String get duracionTexto {
    final horas = minutos ~/ 60;
    final resto = minutos % 60;
    if (horas == 0) return '$minutos min';
    if (resto == 0) return '$horas h';
    return '$horas h $resto min';
  }
}