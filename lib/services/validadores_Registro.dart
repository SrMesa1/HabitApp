import 'package:form_field_validator/form_field_validator.dart';

import '../models/habit.dart';

/// Observación: obligatoria, entre 5 y 120 caracteres.
/// MultiValidator revisa las reglas en orden y muestra el mensaje de la
/// primera que falle.
final validadorObservacion = MultiValidator([
  RequiredValidator(errorText: 'Escribe una observación.'),
  MinLengthValidator(5, errorText: 'Usa al menos 5 caracteres.'),
  MaxLengthValidator(120, errorText: 'Máximo 120 caracteres.'),
]);

/// Minutos: obligatorio, entero y dentro de lo razonable para un día.
/// Regla del dominio: una actividad dura mínimo 1 minuto y máximo 600
/// (10 horas), así que 0 y los negativos se rechazan.
final validadorMinutos = MultiValidator([
  RequiredValidator(errorText: 'Escribe cuántos minutos dedicaste.'),
  PatternValidator(
    r'^\d+$',
    errorText: 'Usa solo números enteros, sin signos ni decimales.',
  ),
  RangeValidator(
    min: 1,
    max: 600,
    errorText: 'Los minutos deben estar entre 1 y 600.',
  ),
]);

/// Regla propia del dominio: la actividad ya ocurrió, así que la fecha es
/// obligatoria y no puede ser futura.
String? validarFechaRegistro(DateTime? fecha) {
  if (fecha == null) return 'Selecciona la fecha de la actividad.';

  final ahora = DateTime.now();
  final hoy = DateTime(ahora.year, ahora.month, ahora.day);
  if (fecha.isAfter(hoy)) return 'La fecha no puede ser futura.';

  return null;
}

/// Exige que se haya elegido uno de los hábitos de la lista.
String? validarHabitoElegido(Habito? habito) {
  if (habito == null) {
    return 'Elige el hábito al que corresponde la actividad.';
  }
  return null;
}