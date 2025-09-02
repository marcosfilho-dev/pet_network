import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/models/data.dart';
import 'package:pet_network/models/pets_post.dart';
 
/// Provider para o repositório de posts.
/// Em uma aplicação real, isso se conectaria a uma API.
final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  return PostsRepository();
});

/// Simula um repositório de dados que busca posts de uma fonte remota.
class PostsRepository {
  /// Busca uma "página" de posts.
  ///
  /// Simula um atraso de rede para imitar uma chamada de API real.
  Future<List<PetPost>> fetchPosts(
      {int page = 0, int limit = 9, String? searchQuery}) async {
    // Simula o atraso da rede
    await Future.delayed(const Duration(seconds: 1));

    // Começa com a lista completa de posts
    List<PetPost> sourcePosts = dummyPetPosts;

    // Se houver um termo de busca, filtra a lista pelo nome do pet
    if (searchQuery != null && searchQuery.isNotEmpty) {
      sourcePosts = sourcePosts
          .where((post) =>
              post.petName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    final int startIndex = page * limit;
    if (startIndex >= sourcePosts.length) {
      // Não há mais posts para buscar
      return [];
    }

    final int endIndex = (startIndex + limit > sourcePosts.length)
        ? sourcePosts.length
        : startIndex + limit;

    return sourcePosts.sublist(startIndex, endIndex);
  }
}