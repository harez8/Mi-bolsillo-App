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

## 5. Configurar Firebase

1. En la [consola de Firebase](https://console.firebase.google.com) crea un proyecto y activa **Authentication → Método de acceso → Correo electrónico/contraseña**.
2. Instala las herramientas (una sola vez): `dart pub global activate flutterfire_cli`.
3. En la carpeta del proyecto: `flutterfire configure` (elige tu proyecto y la plataforma Android). Esto reemplaza `lib/firebase_options.dart` y crea `android/app/google-services.json`.
4. Si el compilador pide `minSdk`, súbelo a **23** en `android/app/build.gradle(.kts)`.

> `google-services.json` y `firebase_options.dart` contienen identificadores públicos del cliente (no son contraseñas) y se incluyen para que el proyecto se pueda ejecutar. **No** se suben claves de firma (`*.jks`, `key.properties`) ni cuentas de servicio; el `.gitignore` los excluye.

## 6. Instalación y ejecución (modo desarrollo)

```bash
flutter create . --project-name mi_bolsillo --org co.edu.pascualbravo   # solo la primera vez
flutter pub get
dart run flutter_launcher_icons   # genera el ícono de la app desde assets/images/logo.png
flutter run                       # emulador Android o dispositivo conectado
flutter test                      # pruebas de la lógica
```

## 7. Generar la APK

**Requisitos:** Flutter SDK, Android SDK (se instala con Android Studio), Firebase ya configurado (sección 5) y un emulador o celular Android para probar.

**Permiso de internet en release:** en `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>` y antes de `<application>`, agrega
`<uses-permission android:name="android.permission.INTERNET"/>`. Sin él, el login puede funcionar en debug y fallar en la APK instalada. En el mismo archivo cambia `android:label` a `Mi Bolsillo`.

**Comandos:**

```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Ubicación de la APK generada:** `build/app/outputs/flutter-apk/app-release.apk`. La copio a `entrega/app.apk` para subirla al repositorio.

**Instalación:**
- Emulador o celular conectado por USB (con depuración USB activa): `adb install -r entrega/app.apk`
- En el emulador también se puede arrastrar el archivo a la ventana. En un celular, copiar el archivo y abrirlo, permitiendo "instalar apps de orígenes desconocidos".

**Resultado de la prueba** _(completar con lo que realmente observes)_:

| Prueba | Resultado |
|---|---|
| La APK se instala y abre | _[ ]_ |
| Registro de cuenta nueva | _[ ]_ |
| Inicio de sesión con credenciales válidas | _[ ]_ |
| Credenciales inválidas muestran mensaje de error | _[ ]_ |
| Cierre de sesión vuelve al login | _[ ]_ |
| Agregar un gasto (con validación de monto vacío/negativo) | _[ ]_ |
| Cerrar y abrir la app conserva los datos | _[ ]_ |
| Dispositivo/emulador y versión de Android usados | _[ ]_ |

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

_[Pega aquí tu captura: `![Captura](entrega/capturas/principal.png)`]_

## 10. Uso de IA


Usé **Claude (Anthropic)** como apoyo para generar una primera versión del código (incluida la autenticación con Firebase) y de este README. Revisé el código, lo ejecuté y puedo explicar y modificar cualquier parte en vivo.
