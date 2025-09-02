import 'package:flutter/material.dart';
import 'package:pet_network/models/pets_post.dart';

class PetPostWidget extends StatelessWidget {
  final PetPost post;

  const PetPostWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos um GestureDetector para futuramente navegar para os detalhes do post
    return GestureDetector(
      onTap: () {
        // TODO: Implementar navegação para a tela de detalhes do post.
        // Exemplo: context.go('/post/${post.id}');
        print('Post ${post.id} clicado!');
      },
      child: Image.network(
        post.imageUrl,
        fit: BoxFit.cover,
        // Adiciona um frame de carregamento para uma melhor UX
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: child,
          );
        },
        // Adiciona um errorBuilder para lidar com assets não encontrados
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.error_outline,
              color: Colors.red[400],
            ),
          );
        },
      ),
    );
  }
}
