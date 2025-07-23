import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  final XFile image;

  const CreatePostScreen({super.key, required this.image});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _tagPeople() {
    // Lógica para marcar pessoas. Pode abrir uma nova tela ou um diálogo.
    // Por enquanto, exibimos uma mensagem.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Funcionalidade de marcar pessoas a ser implementada.')),
    );
  }

  void _sharePost() {
    final caption = _captionController.text;
    // Aqui você implementaria a lógica para fazer o upload da imagem e do post.
    // Por exemplo, chamar um serviço de API.
    debugPrint('Compartilhando post...');
    debugPrint('Imagem: ${widget.image.path}');
    debugPrint('Legenda: $caption');

    // Retorna um mapa com a imagem e a legenda para a tela anterior.
    final postData = {
      'image': widget.image,
      'caption': caption,
    };
    Navigator.of(context).pop(postData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Nova Publicação',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _sharePost,
            child: const Text(
              'Compartilhar',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção para legenda e preview da imagem
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    File(widget.image.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      decoration: const InputDecoration(
                        hintText: 'Escreva uma legenda...',
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Opção para marcar pessoas
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Marcar pessoas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _tagPeople,
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}