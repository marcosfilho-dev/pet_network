import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/user/app_user.dart';

class AuthRepository {
  final _authStateController = StreamController<AppUser?>();
  // Simula um banco de dados de usuários em memória.
  // Em um app real, isso seria uma chamada para o Firebase Auth, API, etc.
  final List<AppUser> _users = [];

  AuthRepository() {
    // Garante que o estado inicial seja "deslogado"
    _authStateController.add(null);
  }

  // O stream que o `authStateChangesProvider` irá ouvir.
  Stream<AppUser?> authStateChanges() => _authStateController.stream;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Simula a chamada de API
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'teste@email.com' && password == 'senha123') {
      // Emite um novo usuário para o stream em caso de sucesso
      _authStateController.add(AppUser(uid: '123', email: email));
    } else {
      // Lança um erro em caso de falha
      throw 'Credenciais inválidas. Tente novamente.';
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // Simula a chamada de API
    await Future.delayed(const Duration(seconds: 2));
    // Verifica se o email já está em uso
    if (_users.any((user) => user.email == email)) {
      throw 'Este email já está em uso. Tente outro.';
    }
    // Cria um novo usuário
    final newUser = AppUser(uid: DateTime.now().toIso8601String(), email: email);
    _users.add(newUser);
    // Emite o novo usuário para o stream, logando-o automaticamente
    _authStateController.add(newUser);
  }

  Future<void> signOut() async {
    // Emite `null` para o stream para deslogar o usuário
    _authStateController.add(null);
  }

  void dispose() => _authStateController.close();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authRepository = AuthRepository();
  ref.onDispose(() => authRepository.dispose());
  return authRepository;
});