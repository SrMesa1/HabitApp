# **HabitApp**

README del proyecto · ET0126 Programación de Dispositivos Móviles

Mi app se llama **HabitApp**. Está dirigida a **un estudiante universitario**, quien necesita **un lugar sencillo para registrar sus hábitos diarios y saber si los está cumpliendo**. La app le ayudará a **no olvidar sus rutinas y a ver su avance** mediante **un registro de hábitos por categoría, una casilla para marcarlos como cumplidos y un anillo de progreso dibujado con Canvas**.

# **Propuesta**

* **Usuario:** estudiantes universitarios que combinan clases, trabajos y rutinas personales (estudiar, hacer ejercicio, leer) y quieren mantener buenos hábitos.

* **Problema:** se les olvidan sus hábitos diarios y no tienen una forma rápida y visual de ver cuánto han cumplido.

* **Solución:** una app donde registran sus hábitos con una categoría, los marcan cuando los cumplen y ven su avance en un indicador circular.

## **Funciones iniciales**

1. Agregar un hábito con nombre y categoría (el nombre se valida antes de aceptarse).

2. Marcar o desmarcar un hábito como cumplido.

3. Eliminar un hábito y consultar el resumen de avance por categoría.

## **Recorrido principal**

1. La persona abre la app y ve la pantalla inicial con la descripción, su progreso y el botón **Agregar hábito**. Si no hay hábitos, ve un mensaje que la invita a crear el primero.

2. Toca **Agregar hábito** y se abre un formulario.

3. Escribe el nombre, elige una categoría y guarda. Si el nombre no es válido, la app muestra el error en el campo.

4. El hábito aparece en la lista y la app muestra un mensaje de confirmación.

5. Cuando cumple el hábito, lo marca; el anillo de progreso se actualiza. Al cerrar y volver a abrir la app, sus hábitos siguen ahí.

## **Datos que se guardan**

Por cada hábito: identificador, nombre, categoría, fecha de creación, si está cumplido y la fecha en que se cumplió (solo existe si el hábito está completado).

## **Canvas**

Un anillo de progreso dibujado con CustomPainter (PintorProgreso) que muestra el porcentaje de hábitos cumplidos. Dibuja el anillo de fondo, un arco proporcional al avance (drawArc) y el porcentaje en el centro.

# **Almacenamiento local**

Elegí **SharedPreferences** porque la app guarda una colección pequeña de hábitos como texto (JSON), sin consultas complejas ni relaciones entre tablas. SQLite sería más pesado para este caso. La lista completa se guarda con jsonEncode bajo la clave habitos y se lee con jsonDecode al abrir la app.

# **Estructura del proyecto**

lib/  
  main.dart  
  screens/  
    home\_screen.dart            \-\> pantalla principal (StatefulWidget)  
  models/  
    habit.dart                  \-\> clase modelo Habito  
  services/  
    storage\_service.dart        \-\> guardar y leer con SharedPreferences  
    validators.dart             \-\> validación del nombre  
    habit\_summary.dart          \-\> resumen: Set, Map y progreso  
  widgets/  
    welcome\_header.dart         \-\> encabezado fijo (StatelessWidget)  
    progress\_card.dart          \-\> tarjeta con el anillo de progreso  
    progress\_painter.dart       \-\> CustomPainter (Canvas)  
    habit\_tile.dart             \-\> fila de cada hábito  
    empty\_state.dart            \-\> mensaje cuando no hay hábitos  
    add\_habit\_form.dart         \-\> formulario con validación (StatefulWidget)  
assets/  
  images/  
    habits\_banner.png           \-\> imagen local del encabezado  
README.md

# **Conceptos de Dart en mi app**

*Los nombres de clases, variables y funciones están en español. Los nombres de los archivos se mantienen como pide la estructura del taller (por ejemplo,* home\_screen.dart *contiene la clase* PantallaInicio*).*

| Concepto | Dónde se ve |
| :---- | :---- |
| Tipos, final/const y null safety | lib/models/habit.dart: atributos final, static const categorias, y DateTime? completadoEn, que es nullable porque solo existe cuando el hábito se completa. |
| Clases y objetos | Clase Habito en lib/models/habit.dart; los objetos se crean en \_agregarHabito (home\_screen.dart) y en Habito.desdeJson. |
| Método del modelo | Habito.alternar() cambia el estado y registra cuándo se completó. |
| Funciones | validarNombreHabito en lib/services/validators.dart y las funciones de ResumenHabitos en lib/services/habit\_summary.dart. |
| List | List\<Habito\> \_habitos en lib/screens/home\_screen.dart. |
| Set | ResumenHabitos.categoriasUnicas en lib/services/habit\_summary.dart. |
| Map | ResumenHabitos.contarPorCategoria en lib/services/habit\_summary.dart. |
| if y for | if/else en validarNombreHabito y \_alternarHabito; for en ResumenHabitos.contarPorCategoria y para construir la lista de hábitos en PantallaInicio.build. |
| while | No se usa (explicación abajo). |

**Sobre while:** no usé while en este primer recorrido porque no hay una repetición finita que lo necesite. Recorro las listas con for, y la interfaz cambia en respuesta a eventos del usuario con setState, sin bucles de espera. La lectura y escritura de datos es asíncrona con async/await, por lo que tampoco se bloquea la interfaz.

# **Captura de pantalla**

| *![][image1]* |
| :---: |

# **Instalación y ejecución**

Requisitos: Flutter SDK y un emulador o dispositivo Android.

flutter pub get  
flutter run

Para comprobar que los datos persisten: agrega un hábito, cierra completamente la app y vuelve a abrirla; el hábito debe seguir en la lista.

# **Uso de IA**

Utilicé Claude (Anthropic) como herramienta de IA para proponer la idea de la app, generar la base del código (modelo, servicios, widgets, Canvas y pantalla principal) y redactar este README.

# **Taller 2: formulario y servicio en memoria**

## **Propósito del flujo**

Un hábito solo dice "cumplido" o "pendiente". El **registro de actividad** le permite al estudiante anotar cuánto tiempo dedicó a un hábito en un día concreto y una observación sobre cómo le fue (por ejemplo, "repasé listas y mapas de Dart"). Así puede ver su esfuerzo real y no solo una casilla marcada. Se abre desde la pantalla principal con el botón **Registrar actividad**.

## **Campos y validaciones**

| Campo | Control | Validación | Mensaje si falla |
| :---- | :---- | :---- | :---- |
| Hábito | Lista desplegable con los hábitos guardados | Obligatorio (validarHabitoElegido) | "Elige el hábito al que corresponde la actividad." |
| Fecha de la actividad | Selector de fecha | Obligatoria y no puede ser futura (validarFechaRegistro, regla propia del dominio) | "Selecciona la fecha de la actividad." "La fecha no puede ser futura." |
| Minutos dedicados | Texto numérico | MultiValidator con RequiredValidator, PatternValidator (solo enteros) y RangeValidator (entre 1 y 600\) | "Escribe cuántos minutos dedicaste." "Usa solo números enteros, sin signos ni decimales." "Los minutos deben estar entre 1 y 600." |
| Observación | Texto de varias líneas | MultiValidator con RequiredValidator, MinLengthValidator (5) y MaxLengthValidator (120) | "Escribe una observación." "Usa al menos 5 caracteres." "Máximo 120 caracteres." |

Los validadores de la biblioteca form\_field\_validator están en lib/services/validadores\_registro.dart. La regla del dominio es que una actividad dura mínimo 1 minuto y máximo 600 (10 horas), y que no se puede registrar una actividad con fecha futura, porque el registro anota algo que ya ocurrió.

## **Modelo y servicio**

* **Modelo (lib/models/registro\_actividad.dart):** la clase RegistroActividad tiene id, habitoId, habitoNombre, fecha, minutos y observacion, todos tipados y final. Tiene el getter claveUnica (hábito \+ día), que usa el servicio para detectar duplicados, y duracionTexto, que muestra "1 h 30 min".

* **Servicio (lib/services/servicio\_registros.dart):** ServicioRegistros ofrece listar() y crear(), ambos asíncronos. Simulan la respuesta de una API con Future.delayed (500 ms y 700 ms). La lista es privada: la pantalla solo recibe una copia no modificable.

* **Regla de negocio:** no se puede registrar el mismo hábito dos veces en el mismo día. Si ocurre, crear() lanza ErrorReglaNegocio y no agrega nada.

* **Pantalla (lib/screens/registro\_actividad\_screen.dart):** StatefulWidget que guarda la GlobalKey\<FormState\>, los controladores, la lista visible y las banderas de carga. Consulta listar() en initState() y libera los controladores en dispose().

* **Widgets sin estado:** TarjetaRegistro y EstadoVacio solo reciben datos y callbacks.

## **Estados que se pueden ver**

| Estado | Qué muestra la app |
| :---- | :---- |
| Cargando lista | Indicador de progreso mientras listar() responde. |
| Lista vacía | Mensaje "Aún no hay registros" y botón "Ir al formulario". |
| Formulario inválido | Errores junto a cada campo; no se llama a crear(). |
| Guardando | Botón deshabilitado con indicador y texto "Guardando..."; los campos se bloquean. |
| Guardado correcto | Mensaje de confirmación, registro al inicio de la lista y formulario limpio. |
| Error del servicio | Mensaje en rojo bajo el botón y en la barra inferior; se conserva lo escrito y no se agrega el registro. |

## **Datos en memoria y datos persistentes**

* **Hábitos (Taller 1):** se guardan con SharedPreferences, así que siguen disponibles al cerrar y abrir la app.

* **Registros de actividad (Taller 2):** viven en una lista static dentro de ServicioRegistros, es decir, en la memoria del proceso. Se conservan mientras la app siga abierta (al salir y volver a entrar a la pantalla se ven), pero **desaparecen al cerrar o reiniciar la app**. Es el comportamiento esperado de esta simulación: no equivale a guardar en SharedPreferences, SQLite ni en una API real.

## **Orden del guardado**

1. Se ejecuta \_claveFormulario.currentState\!.validate().

2. Si hay errores, se detiene sin llamar al servicio.

3. Se marca la pantalla como ocupada (\_guardando \= true) y se bloquea otro envío.

4. Se espera el resultado de crear().

5. Si funciona, se actualiza la lista, se muestra la confirmación y se limpia el formulario.

6. Si falla, se conserva lo escrito y se muestra el error.

7. En el bloque finally se termina el estado de carga si la pantalla sigue montada.

## **Pruebas manuales**

Completa la última columna después de probar la app en el emulador o dispositivo.

| Caso | Acción | Resultado esperado | Resultado obtenido |
| :---- | :---- | :---- | :---- |
| Campos vacíos | Pulsar "Guardar registro" sin escribir. | Aparecen los errores en los cuatro campos y no se agrega un registro. | Cumplido |
| Texto muy corto | Escribir "hola" en Observación. | Aparece "Usa al menos 5 caracteres." | Cumplido |
| Regla de dominio | Escribir 0 (o 700\) en Minutos y pulsar guardar. | Aparece "Los minutos deben estar entre 1 y 600." El selector de fecha tampoco permite elegir días futuros. | Cumplido |
| Registro válido | Completar los cuatro campos y guardar. | Se ve el progreso, la confirmación y el registro en la lista. | Cumplido |
| Error de negocio | Guardar otro registro con el mismo hábito y la misma fecha. | No se duplica y aparece el mensaje de error. | Cumplido |
| Envío rápido | Pulsar "Guardar registro" varias veces durante la demora. | Solo se crea un registro. | Cumplido |
| Reinicio | Cerrar la app por completo y abrirla. | Los hábitos siguen; los registros de actividad desaparecen. | Incumplido |

## **Capturas del Taller 2**

| Formulario | Validación | Resultado |
| ----- | ----- | ----- |
| *![][image2]* | ![][image3] | ![][image4] |

## **Archivos nuevos o modificados**

lib/  
  models/registro\_actividad.dart         (nuevo)  
  services/servicio\_registros.dart       (nuevo)  
  services/validadores\_registro.dart     (nuevo)  
  screens/registro\_actividad\_screen.dart (nuevo)  
  widgets/tarjeta\_registro.dart          (nuevo)  
  widgets/empty\_state.dart               (modificado: texto, icono y botón)  
  screens/home\_screen.dart               (modificado: botón "Registrar actividad")

## **Uso de IA en el Taller 2**

Utilicé Claude para proponer el diseño del flujo y generar el README. 

[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,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>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMIAAABQCAYAAABLT6p5AAAFQElEQVR4Xu3dW0wcVRgHcGJ898VoAjWB8NSXJm0a2hqtxjR9QUypUTQxNUQxxGJp02pML0ZMuFWrVIL1palpbLhVmhZ729AVaLmVUroFFijlsrvshauUS7kM+Mkc3ePMnBm6NrAsO/8v+fWc+ebsdB7mn9lZwhLhcrlIy+l0Unt7e1B1dnYK5wEQLBHyP5OTkyqrVW1tbcIJAgSDYRB+75mlWrekuVSJMr46xkaPx6PZ8/R1qiCfjXa7XThBgJXicDj43DAIfy1aWFhQXK4rXwgCrBYhCPL2apb2BAGCIUJ7IaJQZiwEAbXman5+ntLyLlBOg/Fb96mpKVr3yyhFxTeyuR5l/e8gFOSd0HSsVHkwmhJj4+lgbDTvln2ZROQuo7xGxVIUKsDal/oR2Ww2Np+enlbtez95E70YFU0xkVG8Nzc3p1jxTxAyLLvJnlTK5rsS4mnzxg1PDsL4+Liyj0KFTGk/tLlVU0+p+4/RM88+p+ori13oh3eSdDJVuBMsGYRAqrW1laUUYKUtR8kBkiTJkLJYECalGQDT8vp8FDE7OyvsADCbgIPwwkvrhN7T2Ln40KIcAUKBKgjyxW50wcv9M4XnKO7VV3iv8LdSPk/5bC+dLS7k219nZ1FrVwd/rfI42t7eA+nC/wcQTAHfEQDCGYIAICEIAAyCACAhCAAMggAgaYLwbX4en/s/3rxtu0vllmu85+8n7fmAqhtqyd7TRUVl55f86BUg1OneETa/vE11UV+1VrBRebG/9+EeFgSHz011zXcQBFjTdIMAYDYIAsCiiJmZ/zYuWa6ytzcZOVmqRb2eftbvH/TRpetXeF/5VqjkYhklvPO20Fcy6vs5fR42dvR1896211974jG0b8suV1jo9K9nyTs6xPuZ3x2n2ruNbP7Q5eBrlXM9/nP6Jjebvi/IF/ZDeFAFAcCsEAQACUEAYBAEAAlBAGB0g2CJjGRj1datwj6AtSw5OVnoyXSDAGA2CAKApAmCu7oSwDT8jwBCEADMyjAIFTEx1J6TzebuP25Qf4WFRrofkPPiBarZsYPq3kqg4YedbP+DgnyeLu+dBravLuFNakr5mB+vt6SIqrdsob7zJTQ24GXr5dfL6zt+OMHWjD+eoOa0T1VJBQgGwyAAmAmCACAhCAAMggCmIj9/DrbcE/qGQfA/6MoPsPWJu3hf/thJHrt+/on3bm7fzsZHo0PUcuSw6mEXD74QivpKi1XbhkEACGcIAoAOBAFMy2W5xucIAoC0RBDqdyeycWJ6kv1kWfnQ26f4uwiyzh/zyFtXw7f9T+VyX157L30f277/+SHVOoBQYRgEADPRDcKN2Fiyrl9PY8MDqjuB3PPPtXcFgLVMNwgAZoMgAEgGQdD7NjmAcKYbBACzQRAAJAQBTGykr4fPEQQAySAI3tpb1H3mtKpXuWkj+91i/+8x9xYXCa/zk3/+II/jE2Oq/u2kd8lzs4rN7VmZZNufLrwWYDXoBgHAbHSDMOLoFXoA4Uw3CABm0H48l88RBDCtgIJgqbIKPYBwElAQAMIdggAgIQgADIIAICEIAAyCACAhCAAMggAgIQgATHVcHJ8jCADSEkEYdTnYqPz699F+J03MTPHtpk9S+LzfWkGP/hxWrW05ekQ4LkAoMgwCgJkgCACSThCe/yINIOwdKD1nHATtYlgeXYMDQg9CgxCEgbERYREsj6zr5XSlzabqnaq2srG4qYH3yu83s/Hx3CxtyDxKb5zMpVzLZeF4sHyEIOCOAGbj+ffbVoQgyNxDPoCwp7zmdYMAYEZ/Ax4JdyuHvewzAAAAAElFTkSuQmCC>

[image4]: <data:image/png;base64,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>