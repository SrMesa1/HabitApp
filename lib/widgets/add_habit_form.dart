import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/validators.dart';

/// Formulario para crear un hábito. Es StatefulWidget porque guarda
/// la categoría elegida y el estado del formulario.
class FormularioAgregarHabito extends StatefulWidget {
  final List<String> nombresExistentes;
  final void Function(String nombre, String categoria) alEnviar;

  const FormularioAgregarHabito({
    super.key,
    required this.nombresExistentes,
    required this.alEnviar,
  });

  @override
  State<FormularioAgregarHabito> createState() =>
      _EstadoFormularioAgregarHabito();
}

class _EstadoFormularioAgregarHabito extends State<FormularioAgregarHabito> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorNombre = TextEditingController();
  String _categoria = Habito.categorias.first;

  @override
  void dispose() {
    _controladorNombre.dispose();
    super.dispose();
  }

  void _enviar() {
    if (_claveFormulario.currentState!.validate()) {
      widget.alEnviar(_controladorNombre.text.trim(), _categoria);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _claveFormulario,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nuevo hábito',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controladorNombre,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                border: OutlineInputBorder(),
              ),
              validator: (valor) =>
                  validarNombreHabito(valor, widget.nombresExistentes),
              onFieldSubmitted: (_) => _enviar(),
            ),
            const SizedBox(height: 16),
            const Text('Categoría'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final categoria in Habito.categorias)
                  ChoiceChip(
                    label: Text(categoria),
                    selected: _categoria == categoria,
                    onSelected: (_) => setState(() => _categoria = categoria),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.add),
                label: const Text('Guardar hábito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
