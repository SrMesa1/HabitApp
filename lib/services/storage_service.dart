import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class ServicioAlmacenamiento {
  static const String _clave = 'habitos';

  Future<List<Habito>> cargarHabitos() async {
    final preferencias = await SharedPreferences.getInstance();
    final textoGuardado = preferencias.getString(_clave);
    if (textoGuardado == null) return [];

    try {
      final List<dynamic> decodificado =
          jsonDecode(textoGuardado) as List<dynamic>;
      return decodificado
          .map((elemento) =>
              Habito.desdeJson(elemento as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardarHabitos(List<Habito> habitos) async {
    final preferencias = await SharedPreferences.getInstance();
    final texto = jsonEncode(habitos.map((habito) => habito.aJson()).toList());
    await preferencias.setString(_clave, texto);
  }
}
