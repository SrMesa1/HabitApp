# HabitApp

Mi app se llama HabitApp. Está dirigida a un estudiante universitario, quien necesita un lugar sencillo para registrar sus hábitos diarios y saber si los está cumpliendo. La app le ayudará a no olvidar sus rutinas y a ver su avance mediante un registro de hábitos por categoría, una casilla para marcarlos como cumplidos y un anillo de progreso dibujado con Canvas.

## Propuesta

- Usuario: estudiantes universitarios que combinan clases, trabajos y rutinas personales (estudiar, hacer ejercicio, leer) y quieren mantener buenos hábitos.
- Problema: se les olvidan sus hábitos diarios y no tienen una forma rápida y visual de ver cuánto han cumplido.
- Solución: una app donde registran sus hábitos con una categoría, los marcan cuando los cumplen y ven su avance en un indicador circular.

### Funciones iniciales

1. Agregar un hábito con nombre y categoría (el nombre se valida antes de aceptarse).
2. Marcar o desmarcar un hábito como cumplido.
3. Eliminar un hábito y consultar el resumen de avance por categoría.

### Recorrido principal

1. La persona abre la app y ve la pantalla inicial con la descripción, su progreso y el botón Agregar hábito. Si no hay hábitos, ve un mensaje que la invita a crear el primero.
2. Toca Agregar hábito y se abre un formulario.
3. Escribe el nombre, elige una categoría y guarda. Si el nombre no es válido, la app muestra el error en el campo.
4. El hábito aparece en la lista y la app muestra un mensaje de confirmación.
5. Cuando cumple el hábito, lo marca; el anillo de progreso se actualiza. Al cerrar y volver a abrir la app, sus hábitos siguen ahí.

### Datos que se guardan

Por cada hábito: identificador, nombre, categoría, fecha de creación, si está cumplido y la fecha en que se cumplió (solo existe si el hábito está completado).

### Canvas

Un anillo de progreso dibujado con `CustomPainter` (`PintorProgreso`) que muestra el porcentaje de hábitos cumplidos. Dibuja el anillo de fondo, un arco proporcional al avance (`drawArc`) y el porcentaje en el centro.

## Almacenamiento local

Elegí SharedPreferences porque la app guarda una colección pequeña de hábitos como texto (JSON), sin consultas complejas ni relaciones entre tablas. SQLite sería más pesado para este caso. La lista completa se guarda con `jsonEncode` bajo la clave `habits` y se lee con `jsonDecode` al abrir la app.

Uso de IA

Utilicé Claude (Anthropic) como herramienta de IA para proponer la idea de la app, generar la base del trabajo y redactar el README.