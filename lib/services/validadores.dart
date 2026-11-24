/// Validaciones del formulario de acceso. Devuelven null si el dato es válido.
class Validadores {
  static String? correo(String? texto) {
    final valor = texto?.trim() ?? '';
    if (valor.isEmpty) return 'Escribe tu correo';
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formato.hasMatch(valor)) return 'Correo no válido';
    return null;
  }

  static String? contrasena(String? texto) {
    final valor = texto ?? '';
    if (valor.isEmpty) return 'Escribe tu contraseña';
    if (valor.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }
}
