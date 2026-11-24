import 'package:firebase_auth/firebase_auth.dart';

/// Envuelve FirebaseAuth para que las pantallas no dependan de Firebase.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Emite el usuario actual cada vez que inicia o cierra sesión.
  Stream<User?> get cambiosDeSesion => _auth.authStateChanges();

  Future<void> iniciarSesion(String correo, String contrasena) async {
    await _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
  }

  Future<void> registrar(String correo, String contrasena) async {
    await _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
  }

  Future<void> cerrarSesion() => _auth.signOut();

  /// Traduce los códigos de error de Firebase a mensajes para el usuario.
  static String mensajeDeError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo.';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres).';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Revisa tu red.';
      default:
        return 'No se pudo completar la acción (${e.code}).';
    }
  }
}
