import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/repository/auth_repository.dart';

// O estado do nosso controller será um AsyncValue para representar os estados de carregamento/erro/sucesso.
class SignUpController extends StateNotifier<AsyncValue<void>> {
  SignUpController({required this.authRepository})
      : super(const AsyncData(null));

  final AuthRepository authRepository;

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => authRepository.createUserWithEmailAndPassword(email, password),
    );
  }
}

final signUpControllerProvider =
    StateNotifierProvider.autoDispose<SignUpController, AsyncValue<void>>((ref) {
  return SignUpController(authRepository: ref.watch(authRepositoryProvider));
});