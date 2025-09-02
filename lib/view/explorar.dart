// lib/view/explorar.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/provider/explore_provider.dart';
import 'package:pet_network/view/widgets/pet_post_widget.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  // Mantemos _searchQuery no estado local para controlar a visibilidade do ícone de limpar.
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Adiciona um listener para o scroll para carregar mais posts
    _scrollController.addListener(_onScroll);

    // Adiciona um listener para a barra de busca com debounce
    _searchController.addListener(() {
      // Atualiza o estado local para a UI e aciona a busca com debounce
      if (mounted) setState(() => _searchQuery = _searchController.text);
      _onSearchDebounced();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    // O listener anônimo é removido automaticamente com o dispose do controller.
    _searchController.dispose();
    super.dispose();
  }

  // Chamado quando o usuário rola a tela
  void _onScroll() {
    // Carrega mais itens um pouco antes de chegar ao final da lista
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Chama o método do notifier para buscar a próxima página.
      ref.read(exploreProvider.notifier).fetchNextPage();
    }
  }

  // Aplica um debounce para não fazer buscas a cada tecla digitada
  void _onSearchDebounced() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      // A lógica de busca agora é tratada pelo notifier.
      ref.read(exploreProvider.notifier).search(query);
    });
  }

  // Permite que o usuário "puxe para atualizar" a lista
  Future<void> _refresh() async {
    // Limpa a busca e usa o método de refresh do notifier.
    _searchController.clear();
    // Chamar um método customizado no notifier garante que a busca
    // também seja resetada para uma string vazia no estado do provider.
    await ref.read(exploreProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explorar ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _buildGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nome do pet...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    // Limpar o controller acionará o listener, que
                    // atualizará a UI e iniciará uma nova busca com query vazia.
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final exploreState = ref.watch(exploreProvider);
    final posts = exploreState.posts;

    // Mostra um indicador de carregamento inicial se a lista estiver vazia
    if (exploreState.isLoadingInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (posts.isEmpty) {
      if (exploreState.searchQuery.isNotEmpty) {
        return const Center(child: Text('Nenhum pet encontrado para a sua busca.'));
      } else {
        return const Center(child: Text('Nenhum post para exibir.'));
      }
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(2.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 colunas, como no Instagram
        mainAxisSpacing: 2, // Espaço vertical entre os itens
        crossAxisSpacing: 2, // Espaço horizontal entre os itens
      ),
      // Adiciona +1 ao itemCount para mostrar o indicador de carregamento no final
      itemCount: posts.length + (exploreState.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Se for o último item e ainda houver mais posts, mostra o indicador.
        if (index == posts.length) {
          // Mostra o indicador de "carregando mais"
          return  Center(child: CircularProgressIndicator());
        }
        return PetPostWidget(post: posts[index]);
      },
    );
  }
}