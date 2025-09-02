import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/models/pets_post.dart';
import 'package:pet_network/provider/posts_provider.dart';

/// Define o estado da página Explorar.
/// Isso nos permite gerenciar todos os estados relacionados (posts, carregamento, paginacao)
/// em um único objeto, tornando o código do widget mais limpo.
class ExploreState {
  final List<PetPost> posts;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool hasMore;
  final String searchQuery;
  final int currentPage;

  ExploreState({
    required this.posts,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.searchQuery = '',
    this.currentPage = 0,
  });

  // Estado inicial, usado quando o provider é criado pela primeira vez.
  factory ExploreState.initial() => ExploreState(posts: [], isLoadingInitial: true);

  ExploreState copyWith({
    List<PetPost>? posts,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? hasMore,
    String? searchQuery,
    int? currentPage,
  }) {
    return ExploreState(
      posts: posts ?? this.posts,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// O Notifier que gerencia o `ExploreState`.
/// Contém toda a lógica de negócios para buscar, paginar e pesquisar posts.
class ExploreNotifier extends StateNotifier<ExploreState> {
  ExploreNotifier(this._postsRepository) : super(ExploreState.initial()) {
    // Busca a primeira página de posts assim que o provider é inicializado.
    _fetchPosts();
  }

  final PostsRepository _postsRepository;
  static const int _pageSize = 9;

  // Função interna para buscar posts, usada tanto para a carga inicial quanto para a paginação.
  Future<void> _fetchPosts() async {
    final newPosts = await _postsRepository.fetchPosts(
      page: state.currentPage,
      limit: _pageSize,
      searchQuery: state.searchQuery,
    );

    if (!mounted) return;

    state = state.copyWith(
      posts: [...state.posts, ...newPosts],
      currentPage: state.currentPage + 1,
      hasMore: newPosts.isNotEmpty,
      isLoadingInitial: false,
      isLoadingMore: false,
    );
  }

  /// Busca a próxima página de posts. Chamado pelo scroll infinito.
  Future<void> fetchNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoadingInitial) return;
    state = state.copyWith(isLoadingMore: true);
    await _fetchPosts();
  }

  /// Atualiza o termo de busca e busca os resultados.
  Future<void> search(String query) async {
    state = ExploreState.initial().copyWith(searchQuery: query, posts: []);
    await _fetchPosts();
  }

  /// Reseta e recarrega a lista de posts. Chamado pelo Pull-to-Refresh.
  Future<void> refresh() async {
    state = ExploreState.initial();
    await _fetchPosts();
  }
}

/// O Provider que expõe o `ExploreNotifier` para a UI.
/// A UI irá 'watch' este provider para se reconstruir quando o `ExploreState` mudar.
final exploreProvider = StateNotifierProvider<ExploreNotifier, ExploreState>((ref) {
  return ExploreNotifier(ref.watch(postsRepositoryProvider));
});