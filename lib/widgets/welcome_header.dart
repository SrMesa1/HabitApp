import 'package:flutter/material.dart';

/// Contenido fijo de la pantalla inicial (por eso es StatelessWidget).
class EncabezadoBienvenida extends StatelessWidget {
  const EncabezadoBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/habits_banner.png',
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline),
                    const SizedBox(width: 8),
                    Text('HabitApp', style: temaTexto.titleLarge),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Registra tus hábitos de estudio y bienestar, márcalos '
                  'cuando los cumplas y mira tu progreso.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
