import 'package:flutter/material.dart';
import 'registro_Activivdad_screen.dart';
import '../models/habit.dart';
import '../services/habit_summary.dart';
import '../services/storage_service.dart';
import '../widgets/add_habit_form.dart';
import '../widgets/empty_state.dart';
import '../widgets/habit_tile.dart';
import '../widgets/progress_card.dart';
import '../widgets/welcome_header.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _EstadoPantallaInicio();
}

class _EstadoPantallaInicio extends State<PantallaInicio> {
  final ServicioAlmacenamiento _almacenamiento = ServicioAlmacenamiento();

  List<Habito> _habitos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarHabitos();
  }

  Future<void> _cargarHabitos() async {
    final cargados = await _almacenamiento.cargarHabitos();
    if (!mounted) return;
    setState(() {
      _habitos = cargados;
      _cargando = false;
    });
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  void _agregarHabito(String nombre, String categoria) {
    final habito = Habito(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: nombre,
      categoria: categoria,
    );
    setState(() => _habitos.add(habito));
    _almacenamiento.guardarHabitos(_habitos);
    _mostrarMensaje('Hábito "$nombre" agregado');
  }

  void _alternarHabito(Habito habito) {
    setState(() => habito.alternar());
    _almacenamiento.guardarHabitos(_habitos);

    if (ResumenHabitos.progreso(_habitos) == 1.0) {
      _mostrarMensaje('¡Completaste todos tus hábitos!');
    } else if (habito.completado) {
      _mostrarMensaje('¡Bien hecho! Hábito completado');
    }
  }

  void _eliminarHabito(Habito habito) {
    setState(() => _habitos.remove(habito));
    _almacenamiento.guardarHabitos(_habitos);
    _mostrarMensaje('Hábito eliminado');
  }

  void _abrirFormulario() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (contextoHoja) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(contextoHoja).viewInsets.bottom,
        ),
        child: FormularioAgregarHabito(
          nombresExistentes: [for (final habito in _habitos) habito.nombre],
          alEnviar: _agregarHabito,
        ),
      ),
    );
  }

    /// Taller 2: abre el flujo de registro de actividad (datos en memoria).
  void _abrirRegistroActividad() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PantallaRegistroActividad(
          habitos: List<Habito>.unmodifiable(_habitos),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HabitApp')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Agregar hábito'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                const EncabezadoBienvenida(),
                const SizedBox(height: 8),
                TarjetaProgreso(
                  completados: ResumenHabitos.cantidadCompletados(_habitos),
                  total: _habitos.length,
                  progreso: ResumenHabitos.progreso(_habitos),
                  categorias: ResumenHabitos.categoriasUnicas(_habitos),
                  conteoPorCategoria:
                      ResumenHabitos.contarPorCategoria(_habitos),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _abrirRegistroActividad,
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Registrar actividad'),
                ),
                   const SizedBox(height: 8),
                if (_habitos.isEmpty)
                  const EstadoVacio()
                else
                  for (final habito in _habitos)
                    ItemHabito(
                      habito: habito,
                      alAlternar: () => _alternarHabito(habito),
                      alEliminar: () => _eliminarHabito(habito),
                    ),
              ],
            ),
    );
  }
}
