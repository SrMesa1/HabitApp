import 'package:flutter/material.dart';
import 'package:habitos/models/registro_Actividad.dart';
import 'package:habitos/services/servicios_registro.dart';
import 'package:habitos/services/validadores_Registro.dart';
import 'package:habitos/widgets/empty_state.dart';
import 'package:habitos/widgets/tarjeta_Registro.dart';
import '../models/habit.dart';

/// Pantalla del taller 2: formulario para registrar actividad y lista con
/// los registros creados. Es StatefulWidget porque administra el formulario,
/// la carga y el resultado del servicio.
class PantallaRegistroActividad extends StatefulWidget {
  final List<Habito> habitos;

  const PantallaRegistroActividad({super.key, required this.habitos});

  @override
  State<PantallaRegistroActividad> createState() =>
      _EstadoPantallaRegistroActividad();
}

class _EstadoPantallaRegistroActividad
    extends State<PantallaRegistroActividad> {
  final ServicioRegistros _servicio = ServicioRegistros();

  // La llave se declara en el State, no dentro de build().
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorFecha = TextEditingController();
  final _controladorMinutos = TextEditingController();
  final _controladorObservacion = TextEditingController();
  final _controladorScroll = ScrollController();

  Habito? _habitoElegido;
  DateTime? _fecha;
  int _versionFormulario = 0; // cambia para reiniciar el desplegable

  List<RegistroActividad> _registros = [];
  bool _cargandoLista = true;
  bool _guardando = false;
  String? _errorLista;
  String? _errorGuardado;

  @override
  void initState() {
    super.initState();
    _cargarRegistros(); // se consulta al entrar, nunca desde build()
  }

  @override
  void dispose() {
    _controladorFecha.dispose();
    _controladorMinutos.dispose();
    _controladorObservacion.dispose();
    _controladorScroll.dispose();
    super.dispose();
  }

  Future<void> _cargarRegistros() async {
    try {
      final lista = await _servicio.listar();
      if (!mounted) return;
      setState(() {
        _registros = lista;
        _errorLista = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorLista = 'No se pudieron cargar los registros.');
    } finally {
      if (mounted) setState(() => _cargandoLista = false);
    }
  }

  void _reintentarCarga() {
    setState(() {
      _cargandoLista = true;
      _errorLista = null;
    });
    _cargarRegistros();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: DateTime(hoy.year - 1, hoy.month, hoy.day),
      lastDate: hoy,
      helpText: 'Fecha de la actividad',
    );

    if (elegida == null || !mounted) return;
    setState(() {
      _fecha = elegida;
      _controladorFecha.text = formatearFecha(elegida);
    });
  }

  void _mostrarMensaje(String texto, {bool esError = false}) {
    final colores = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: esError ? colores.error : null,
          content: Text(
            texto,
            style: esError ? TextStyle(color: colores.onError) : null,
          ),
        ),
      );
  }

  void _limpiarFormulario() {
    _controladorFecha.clear();
    _controladorMinutos.clear();
    _controladorObservacion.clear();
    _claveFormulario.currentState?.reset(); // quita los mensajes de error
    setState(() {
      _habitoElegido = null;
      _fecha = null;
      _versionFormulario++;
    });
  }

  Future<void> _guardar() async {
    // Protección contra envíos repetidos.
    if (_guardando) return;

    // 1 y 2. Validar; si hay errores, no se llama al servicio.
    if (!_claveFormulario.currentState!.validate()) return;

    // 3. Marcar la pantalla como ocupada.
    setState(() {
      _guardando = true;
      _errorGuardado = null;
    });

    try {
      final habito = _habitoElegido!;
      final nuevo = RegistroActividad(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        habitoId: habito.id,
        habitoNombre: habito.nombre,
        fecha: _fecha!,
        minutos: int.parse(_controladorMinutos.text.trim()),
        observacion: _controladorObservacion.text.trim(),
      );

      // 4. Esperar el resultado de crear().
      final creado = await _servicio.crear(nuevo);
      if (!mounted) return;

      // 5. Éxito: actualizar la lista, confirmar y limpiar el formulario.
      setState(() => _registros = [creado, ..._registros]);
      _limpiarFormulario();
      _mostrarMensaje(
        'Registro guardado: ${creado.habitoNombre} (${creado.duracionTexto})',
      );
    } on ErrorReglaNegocio catch (error) {
      // 6. Falla de negocio: se conservan los datos escritos.
      if (!mounted) return;
      setState(() => _errorGuardado = error.mensaje);
      _mostrarMensaje(error.mensaje, esError: true);
    } catch (_) {
      if (!mounted) return;
      const mensaje = 'Ocurrió un error inesperado. Intenta de nuevo.';
      setState(() => _errorGuardado = mensaje);
      _mostrarMensaje(mensaje, esError: true);
    } finally {
      // 7. En cualquier caso, terminar el estado de carga.
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _irAlFormulario() {
    if (!_controladorScroll.hasClients) return;
    _controladorScroll.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de actividad')),
      body: SingleChildScrollView(
        controller: _controladorScroll,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nuevo registro', style: temaTexto.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Anota cuánto tiempo dedicaste a uno de tus hábitos '
              'y una observación sobre cómo te fue.',
            ),
            const SizedBox(height: 16),
            if (widget.habitos.isEmpty)
              const _AvisoSinHabitos()
            else
              _construirFormulario(),
            const SizedBox(height: 24),
            Text('Registros recientes', style: temaTexto.titleLarge),
            const SizedBox(height: 8),
            _construirLista(),
          ],
        ),
      ),
    );
  }

  Widget _construirFormulario() {
    final colores = Theme.of(context).colorScheme;

    return Form(
      key: _claveFormulario,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<Habito>(
            key: ValueKey('desplegable-habito-$_versionFormulario'),
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Hábito',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final habito in widget.habitos)
                DropdownMenuItem<Habito>(
                  value: habito,
                  child: Text(habito.nombre, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: _guardando ? null : (valor) => _habitoElegido = valor,
            validator: validarHabitoElegido,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _controladorFecha,
            readOnly: true,
            enabled: !_guardando,
            onTap: _elegirFecha,
            decoration: const InputDecoration(
              labelText: 'Fecha de la actividad',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            validator: (_) => validarFechaRegistro(_fecha),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _controladorMinutos,
            enabled: !_guardando,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutos dedicados',
              border: OutlineInputBorder(),
            ),
            validator: (valor) => validadorMinutos(valor),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _controladorObservacion,
            enabled: !_guardando,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Observación',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (valor) => validadorObservacion(valor),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            // Deshabilitado mientras guarda: evita crear copias del registro.
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_guardando ? 'Guardando...' : 'Guardar registro'),
          ),
          if (_errorGuardado != null) ...[
            const SizedBox(height: 12),
            Card(
              color: colores.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colores.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorGuardado!,
                        style: TextStyle(color: colores.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _construirLista() {
    // Estado: cargando la lista
    if (_cargandoLista) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Estado: error al listar
    if (_errorLista != null) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Text(_errorLista!),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _reintentarCarga,
            child: const Text('Reintentar'),
          ),
        ],
      );
    }

    // Estado: lista vacía
    if (_registros.isEmpty) {
      return EstadoVacio(
        icono: Icons.event_note,
        titulo: 'Aún no hay registros',
        mensaje: 'Completa el formulario para crear tu primer '
            'registro de actividad.',
        textoBoton: 'Ir al formulario',
        alPresionar: _irAlFormulario,
      );
    }

    return Column(
      children: [
        for (final registro in _registros) TarjetaRegistro(registro: registro),
      ],
    );
  }
}

/// Aviso fijo cuando todavía no hay hábitos a los que asociar la actividad.
class _AvisoSinHabitos extends StatelessWidget {
  const _AvisoSinHabitos();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Primero agrega un hábito en la pantalla principal para '
                'poder registrar actividad.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}