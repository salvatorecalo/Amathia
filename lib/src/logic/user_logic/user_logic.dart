import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider di autenticazione
final authControllerProvider = Provider((ref) => AuthController());

class AuthController {
  final supabase = Supabase.instance.client;

  // SIGNUP
  Future<String?> signUp(String email, String password, String name) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'first_name': name},
      );

      if (res.user != null) {
        return null;
      }
    } on AuthException catch (e) {
      return e.message;
    }
    return null;
  }

  // LOGIN
  Future<String?> signIn(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        return null;
      } else {
        return "User not found";
      }
    } on AuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Inserisci una mail';
    }
    return !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  // OTTIENI L'UTENTE ATTUALE
  User? getUser() {
    return supabase.auth.currentUser;
  }

  // ELIMINA ACCOUNT
  Future<void> deleteAccount(String userId) async {
    await supabase.auth.admin.deleteUser(userId);
    await supabase.auth.signOut();
  }

  // OTTIENI IL NOME UTENTE
  String? getUsername(User user) {
    return user.userMetadata?['first_name'];
  }
}
