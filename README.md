# Mi Bolsillo

**I.U. Pascual Bravo · ET0126 · Programación de Dispositivos Móviles** · Taller final (lanzamiento)
Autor: _Heider Restrepo_

## 1. Propuesta

> Mi app se llama **Mi Bolsillo**. Está dirigida a **estudiantes universitarios que manejan una mesada o un ingreso pequeño**, quienes necesitan **saber en qué se les va el dinero y llegar a fin de mes sin sorpresas**. La app le ayudará a **tener control de sus finanzas personales** mediante **el registro de ingresos y gastos, un resumen con balance y una meta de ahorro**.

| Elemento | Descripción |
|---|---|
| **Nombre** | Mi Bolsillo |
| **Usuario** | Estudiante universitario con ingresos limitados (mesada, monitoría, trabajo parcial). |
| **Problema** | No lleva registro de lo que gasta, no sabe en qué categorías se le va el dinero y no puede planear ahorros. |
| **Solución** | Una app móvil donde registra cada ingreso o gasto en segundos y ve su balance, un gráfico de gastos por categoría y cuánto le falta para su meta de ahorro. |

### Funciones
0. Crear una cuenta e iniciar o cerrar sesión con **Firebase Authentication** (correo y contraseña). Cada usuario ve solo sus propios datos.
1. Registrar un ingreso o un gasto (con descripción, monto, categoría y nota opcional).
2. Consultar la lista de movimientos, filtrarla por categoría y eliminar movimientos.
3. Definir una meta de ahorro y ver el progreso y el tiempo estimado para alcanzarla.

### Recorrido principal
1. Abre la app y ve su balance, su meta de ahorro y (si ya hay datos) el gráfico de gastos.
2. Toca **Agregar movimiento**.
3. Elige si es gasto o ingreso, completa el formulario y guarda.
4. Ve el nuevo movimiento en la lista, el balance actualizado y el gráfico redibujado.
5. Cierra la app; al abrirla de nuevo, todo sigue ahí.

### Datos que guarda
- Lista de movimientos (id, descripción, monto, tipo, categoría, fecha, nota).
- Meta de ahorro del usuario.

### Canvas
Una **dona de gastos por categoría** dibujada con `CustomPainter` (`lib/widgets/grafico_gastos.dart`). Cada arco representa el porcentaje del gasto total de una categoría, para ver de un vistazo dónde se va el dinero.

## 2. Almacenamiento local: SharedPreferences

Elegí **SharedPreferences** porque el volumen de datos de un estudiante es pequeño (decenas o pocos cientos de movimientos) y no necesito consultas complejas: guardo la lista completa como un JSON y la meta de ahorro como un número. Es más simple de explicar y mantener que SQLite. Si la app creciera (reportes por rango de fechas, miles de registros), migraría a SQLite.

## 3. Conceptos de Dart en mi app

| Concepto | Dónde se ve |
|---|---|
| Tipos, `final`/`const`, null safety | `lib/models/movimiento.dart`: atributos `final`, `nota` es `String?` porque es opcional; listas `const` de categorías. |
| Clases y objetos | `Movimiento` (modelo) y objetos creados en `agregar_movimiento_sheet.dart`. |
| Método del modelo | `Movimiento.valorConSigno()`, `toJson()` y `fromJson()`. |
| Funciones | `Finanzas.validarMonto`, `totalPorTipo`, `formatearPesos` en `lib/services/finanzas.dart`. |
| `List` | `_movimientos` en `home_screen.dart`. |
| `Set` | `Finanzas.categoriasUsadas` devuelve categorías sin repetir; se usan como chips de filtro. |
| `Map` | `Finanzas.gastosPorCategoria` (categoría → total), usado por el gráfico. |
| `if` y `for` | `Finanzas.totalPorTipo` (for + if) y las listas con `for` en la interfaz. |
| `while` | `Finanzas.mesesParaMeta`: repite mientras el ahorro acumulado no alcance la meta (con tope de 600 meses para que siempre termine). |

## 4. Estructura

```
lib/
  main.dart
  firebase_options.dart        (lo genera flutterfire configure)
  screens/
    auth_gate.dart             (decide entre login y pantalla principal)
    login_screen.dart
    home_screen.dart
  widgets/
    agregar_movimiento_sheet.dart
    grafico_gastos.dart
    movimiento_tile.dart
    resumen_card.dart
  models/movimiento.dart
  services/
    auth_service.dart
    validadores.dart
    finanzas.dart
    storage_service.dart
assets/images/logo.png
test/widget_test.dart
```
**Instalación:**
- Emulador o celular conectado por USB (con depuración USB activa): `adb install -r entrega/app.apk`
- En el emulador también se puede arrastrar el archivo a la ventana. En un celular, copiar el archivo y abrirlo, permitiendo "instalar apps de orígenes desconocidos".

**Resultado de la prueba** _(completar con lo que realmente observes)_:


### APK vs. paquete para Google Play

- La **APK** es un solo archivo instalable que contiene el código para todas las arquitecturas y recursos. Es lo que entrego: sirve para instalar y probar directamente. Por defecto, Flutter la firma con la clave de **depuración**, lo cual es válido para esta práctica pero no para publicar.
- Para una **publicación nueva en Google Play** se exige el formato **Android App Bundle (`.aab`)**, que se sube a Play Console; con él Google genera APK optimizados para cada dispositivo (menor tamaño de descarga). Además requiere firmar con una clave propia de publicación y activar **Play App Signing**.
- Comando para generar el bundle (no es obligatorio entregarlo): `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`.

**Fuente consultada:** Ayuda de Play Console, *Acerca de Android App Bundles* — https://support.google.com/googleplay/android-developer/answer/9844279 (indica que las apps nuevas deben publicarse con Android App Bundle y que se debe usar Play App Signing). Consultada el 23 de noviembre de 2026; conviene releerla antes de publicar, porque los requisitos de la tienda cambian (por ejemplo, el nivel de API objetivo).

## 8. Limitaciones conocidas

- Los movimientos se guardan solo en el dispositivo (SharedPreferences): si se desinstala la app o se cambia de celular, se pierden. Firebase se usa únicamente para autenticar.
- No hay recuperación de contraseña ni verificación de correo.
- La meta de ahorro y el cálculo de meses son una estimación simple basada en el balance del mes actual.
- _[Agrega aquí cualquier función que no hayas logrado terminar]_

## 9. Captura de pantalla



## 10. Uso de IA


Usé **Claude (Anthropic)** como apoyo para generar una primera versión del código (incluida la autenticación con Firebase) y de este README. Revisé el código, lo ejecuté.
