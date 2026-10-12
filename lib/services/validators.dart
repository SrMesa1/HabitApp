
String? validarNombreHabito(String? valor, List<String> nombresExistentes) {
  final texto = valor?.trim() ?? '';

  if (texto.isEmpty) return 'Escribe el nombre del hábito';
  if (texto.length < 3) return 'Usa al menos 3 caracteres';
  if (texto.length > 40) return 'Máximo 40 caracteres';

  final repetido = nombresExistentes
      .any((nombre) => nombre.toLowerCase() == texto.toLowerCase());
  if (repetido) return 'Ya existe un hábito con ese nombre';

  return null;
}
