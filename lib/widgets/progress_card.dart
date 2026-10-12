import 'package:flutter/material.dart';

import 'progress_painter.dart';

/// Tarjeta con el anillo de progreso (Canvas) y el resumen por categoría.
class TarjetaProgreso extends StatelessWidget {
  final int completados;
  final int total;
  final double progreso;
  final Set<String> categorias;
  final Map<String, int> conteoPorCategoria;

  const TarjetaProgreso({
    super.key,
    required this.completados,
    required this.total,
    required this.progreso,
    required this.categorias,
    required this.conteoPorCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final palabraCategoria = categorias.length == 1 ? 'categoría' : 'categorías';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: PintorProgreso(
                  progreso: progreso,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu progreso',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('$completados de $total completados'),
                  Text('${categorias.length} $palabraCategoria'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final entrada in conteoPorCategoria.entries)
                        Chip(label: Text('${entrada.key}: ${entrada.value}')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
