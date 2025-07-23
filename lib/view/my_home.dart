import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pet_network/models/post_model.dart';
import 'package:pet_network/routes.dart';
import 'package:pet_network/view/create_post/create_post_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});


  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Post> _posts = [];

  Future<void> _showImageSourceDialog() async {
    // Mostra um diálogo para o usuário escolher entre câmera e galeria
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tirar Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    Map<String, dynamic>? postData;

    if (source == ImageSource.camera) {
      final result = await Navigator.pushNamed(context, AppRoutes.camera);
      if (result is Map<String, dynamic>) {
        postData = result;
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        if (!mounted) return;
        // Navega para a tela de criação de post e aguarda o resultado
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreatePostScreen(image: pickedFile)),
        );
        if (result is Map<String, dynamic>) {
          postData = result;
        }
      }
    }

    if (postData != null) {
      final newPost = Post(
        image: postData['image'],
        caption: postData['caption'],
      );
      setState(() {
        _posts.insert(0, newPost);
      });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Text('PetSocial',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white10,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            iconSize: 35,
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
            onPressed: _showImageSourceDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
            rippleColor: Colors.grey,
            hoverColor: Colors.grey,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 100),
            haptic: true,
            curve: Curves.easeInOutExpo,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.search,
                text: 'Explorar',
              ),
              GButton(
                icon: LineIcons.bell,
                text: 'notificacoes',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Perfil',
              ),
            ]),
      ),
    );
  }

  Widget _buildBody() {
    if (_posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Nenhuma postagem ainda. Toque na câmera para criar uma!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do post
              Image.file(File(post.image.path)),

              // Legenda do post
              if (post.caption != null && post.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 12.0,
                    bottom: 4.0,
                  ),
                  child: Text(
                    post.caption!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              // Barra de ações (Curtir, Comentar, Compartilhar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Atualiza o estado da curtida e reconstrói o widget
                        setState(() {
                          post.isLiked = !post.isLiked;
                        });
                      },
                      icon: Icon(
                        post.isLiked ? LineIcons.heartAlt : LineIcons.heart,
                        color: post.isLiked ? Colors.red : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Lógica para adicionar um comentário
                        debugPrint(
                            'Botão de comentar pressionado no post $index');
                      },
                      icon: const Icon(LineIcons.comment),
                    ),
                    IconButton(
                      onPressed: () {
                        // Lógica para compartilhar o post
                        debugPrint(
                            'Botão de compartilhar pressionado no post $index');
                      },
                      icon: const Icon(LineIcons.share),
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildBody(),
    );
  }
}
