import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> iniciarSesion(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _traducir(e.code);
    }
  }

  Future<String?> registrar(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _traducir(e.code);
    }
  }

  Future<void> cerrarSesion() => _auth.signOut();

  String _traducir(String codigo) {
    switch (codigo) {
      case 'invalid-email':
        return 'El formato del email no es válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Ese email ya está registrado.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Email o contraseña incorrectos.';
      default:
        return 'Ocurrió un error. Intentá de nuevo.';
    }
  }
}