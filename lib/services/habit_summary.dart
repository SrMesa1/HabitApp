import '../models/habit.dart';

class ResumenHabitos {
  const ResumenHabitos._();

  static Set<String> categoriasUnicas(List<Habito> habitos) {
    final Set<String> resultado = {};
    for (final habito in habitos) {
      resultado.add(habito.categoria);
    }
    return resultado;
  }

  static Map<String, int> contarPorCategoria(List<Habito> habitos) {
    final Map<String, int> conteos = {};
    for (final habito in habitos) {
      conteos[habito.categoria] = (conteos[habito.categoria] ?? 0) + 1;
    }
    return conteos;
  }

  static int cantidadCompletados(List<Habito> habitos) =>
      habitos.where((habito) => habito.completado).length;

  /// Avance entre 0.0 y 1.0 (lo usa el Canvas).
  static double progreso(List<Habito> habitos) {
    if (habitos.isEmpty) return 0;
    return cantidadCompletados(habitos) / habitos.length;
  }
}
