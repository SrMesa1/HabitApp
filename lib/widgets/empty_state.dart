import 'package:flutter/material.dart';

/// Se muestra cuando todavía no hay hábitos registrados.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.playlist_add_check, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Aún no tienes hábitos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Toca "Agregar hábito" para crear el primero.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
