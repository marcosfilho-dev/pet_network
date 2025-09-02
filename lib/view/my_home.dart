import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pet_network/models/data.dart';
import 'package:pet_network/models/pets_post.dart';
import 'package:pet_network/view/widgets/pet_post_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text('PetSocial',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LineIcons.plusSquare, color: Colors.black),
            onPressed: () {
              // TODO: Implementar fluxo de criação de post
              print('Botão de criar post pressionado!');
            },
          ),
          IconButton(
            icon: const Icon(LineIcons.facebookMessenger, color: Colors.black),
            onPressed: () {
              // TODO: Implementar tela de mensagens
              print('Botão de mensagens pressionado!');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyPetPosts.length,
        itemBuilder: (context, index) {
          // Usamos o operador de módulo para ciclar pelos posts, criando um feed "infinito"
          final post = dummyPetPosts[index % dummyPetPosts.length];
          return _PostCard(post: post);
        },
      ),
    );
  }
}

/// Um widget de card para exibir um post completo no feed.
class _PostCard extends StatefulWidget {
  final PetPost post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  // O estado de 'curtido' e a contagem de likes são gerenciados localmente no card.
  bool _isLiked = false;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post.likes;
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likesCount--;
        _isLiked = false;
      } else {
        _likesCount++;
        _isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Post (Avatar e Nome)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  // Gera um avatar a partir da URL do post para manter a consistência
                  backgroundImage: NetworkImage(widget.post.imageUrl),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.post.petName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Imagem do post (usando o mesmo widget da tela Explorar)
          PetPostWidget(post: widget.post),

          // Barra de ações (Curtir, Comentar, Compartilhar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? LineIcons.heartAlt : LineIcons.heart,
                    color: _isLiked ? Colors.red : null,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LineIcons.comment),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LineIcons.share),
                ),
              ],
            ),
          ),

          // Contagem de curtidas e legenda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_likesCount curtidas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '${widget.post.petName} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text: 'Olha que dia lindo para passear! 🐾 #doglife'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
