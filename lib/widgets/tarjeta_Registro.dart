import 'package:flutter/material.dart';
import 'package:habitos/models/registro_Actividad.dart';


/// Muestra un registro de actividad. Es StatelessWidget porque solo
/// recibe datos y los dibuja.
class TarjetaRegistro extends StatelessWidget {
  final RegistroActividad registro;

  const TarjetaRegistro({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.timer_outlined)),
        title: Text(registro.habitoNombre),
        subtitle: Text(
          '${registro.fechaTexto} · ${registro.duracionTexto}\n'
          '${registro.observacion}',
        ),
        isThreeLine: true,
      ),
    );
  }
}