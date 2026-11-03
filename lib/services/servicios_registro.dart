import '../models/registro_Actividad.dart';

/// Error controlado: se lanza cuando se incumple una regla de negocio.
class ErrorReglaNegocio implements Exception {
  final String mensaje;

  const ErrorReglaNegocio(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Servicio en memoria que simula el comportamiento de una API.
///
/// Los registros viven en la memoria del proceso: desaparecen al cerrar la
/// app. Los hábitos, en cambio, se guardan con SharedPreferences.
class ServicioRegistros {
  // Lista privada: la pantalla nunca la modifica directamente.
  static final List<RegistroActividad> _registros = [];

  /// Devuelve los registros, del más reciente al más antiguo.
  Future<List<RegistroActividad>> listar() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula la red
    return List<RegistroActividad>.unmodifiable(_registros);
  }

  /// Crea un registro. Regla de negocio: no se puede registrar dos veces
  /// el mismo hábito en el mismo día.
  Future<RegistroActividad> crear(RegistroActividad registro) async {
    await Future.delayed(const Duration(milliseconds: 700)); // simula la red

    final existe = _registros.any(
      (actual) => actual.claveUnica == registro.claveUnica,
    );
    if (existe) {
      throw ErrorReglaNegocio(
        'Ya registraste actividad de "${registro.habitoNombre}" '
        'el ${registro.fechaTexto}. Elige otro hábito u otra fecha.',
      );
    }

    _registros.insert(0, registro);
    return registro;
  }
}