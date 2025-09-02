import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/repository/auth_repository.dart';

// O estado do nosso controller será um AsyncValue para representar os estados de carregamento/erro/sucesso.
class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController({required this.authRepository}) : super(const AsyncData(null));

  final AuthRepository authRepository;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => authRepository.signInWithEmailAndPassword(email, password),
    );
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<void>>((ref) {
  return LoginController(authRepository: ref.watch(authRepositoryProvider));
});