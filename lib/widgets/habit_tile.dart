import 'package:flutter/material.dart';

import '../models/habit.dart';

class ItemHabito extends StatelessWidget {
  final Habito habito;
  final VoidCallback alAlternar;
  final VoidCallback alEliminar;

  const ItemHabito({
    super.key,
    required this.habito,
    required this.alAlternar,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: alAlternar,
        leading: Checkbox(
          value: habito.completado,
          onChanged: (_) => alAlternar(),
        ),
        title: Text(
          habito.nombre,
          style: TextStyle(
            decoration: habito.completado ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${habito.categoria} · ${habito.etiquetaEstado}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Eliminar',
          onPressed: alEliminar,
        ),
      ),
    );
  }
}
