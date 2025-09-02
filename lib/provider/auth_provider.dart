import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/repository/auth_repository.dart';

final authStateChangesProvider = StreamProvider.autoDispose((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});