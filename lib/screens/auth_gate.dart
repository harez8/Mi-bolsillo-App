import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Decide qué pantalla mostrar según haya o no sesión iniciada.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().cambiosDeSesion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final usuario = snapshot.data;
        if (usuario == null) return const LoginScreen();
        return HomeScreen(uid: usuario.uid, correo: usuario.email ?? 'usuario');
      },
    );
  }
}
