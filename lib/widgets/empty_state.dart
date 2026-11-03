import 'package:flutter/material.dart';

/// Se muestra cuando no hay elementos para mostrar. Sin parámetros usa el
/// texto de "sin hábitos"; el taller 2 lo reutiliza para "sin registros".
class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final String? textoBoton;
  final VoidCallback? alPresionar;

  const EstadoVacio({
    super.key,
    this.icono = Icons.playlist_add_check,
    this.titulo = 'Aún no tienes hábitos',
    this.mensaje = 'Toca "Agregar hábito" para crear el primero.',
    this.textoBoton,
    this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icono, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(mensaje, textAlign: TextAlign.center),
          if (textoBoton != null && alPresionar != null) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: alPresionar,
              child: Text(textoBoton!),
            ),
          ],
        ],
      ),
    );
  }
}