// TODO Implement this library.
import 'package:camera/camera.dart'; // This import is correct and exists.
import 'package:flutter/material.dart';
import 'package:pet_network/view/create_post/create_post_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; // 0 for back camera, 1 for front camera
  FlashMode _currentFlashMode = FlashMode.off;

  // Mapeia os modos de flash para ícones para fácil visualização
  final Map<FlashMode, IconData> _flashIcons = {
    FlashMode.off: Icons.flash_off,
    FlashMode.auto: Icons.flash_auto,
    FlashMode.always: Icons.flash_on,
  };

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      // Inicializa com a câmera selecionada (padrão: traseira)
      _initializeCamera(widget.cameras[_selectedCameraIndex]);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    // Descarta o controller antigo antes de criar um novo
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // Garante que o modo de flash seja aplicado ao novo controller
    await _controller!.setFlashMode(_currentFlashMode);

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      debugPrint("Erro ao inicializar a câmera: $e");
      // Opcional: mostrar um erro para o usuário
    }
  }

  Future<void> _takePicture() async {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      debugPrint('Erro: Câmera não inicializada.');
      return;
    }

    if (cameraController.value.isTakingPicture) {
      // Uma captura já está em andamento, não faça nada.
      return;
    }

    try {
      final XFile image = await cameraController.takePicture();
      if (!mounted) return;
      // Navega para a tela de criação de post e aguarda um resultado.
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostScreen(image: image)),
      );

      // Se a tela de criação de post retornou um resultado (a imagem),
      // pop a tela da câmera e passa o resultado para a tela anterior (MyHomePage).
      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    } on CameraException catch (e) {
      debugPrint('Erro ao tirar foto: $e');
    }
  }

  void _switchCamera() {
    if (widget.cameras.length > 1) {
      // Alterna para a próxima câmera na lista
      _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
      _initializeCamera(widget.cameras[_selectedCameraIndex]);
    }
  }

  void _cycleFlashMode() {
    final List<FlashMode> flashModes = [
      FlashMode.off,
      FlashMode.auto,
      FlashMode.always,
    ];
    final currentModeIndex = flashModes.indexOf(_currentFlashMode);
    final nextModeIndex = (currentModeIndex + 1) % flashModes.length;
    final nextFlashMode = flashModes[nextModeIndex];

    setState(() {
      _currentFlashMode = nextFlashMode;
    });
    _controller!.setFlashMode(nextFlashMode);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CameraPreview(_controller!)),
          Positioned(
            bottom: 50,
            child: IconButton(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera, color: Colors.white, size: 70),
              style: IconButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 4),
              ),
            ),
          ),
          // Botão para controlar o flash
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: _cycleFlashMode,
              icon: Icon(_flashIcons[_currentFlashMode],
                  color: Colors.white, size: 35),
            ),
          ),
          // Botão para trocar de câmera
          if (widget.cameras.length > 1)
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                onPressed: _switchCamera,
                icon: const Icon(Icons.flip_camera_ios_outlined,
                    color: Colors.white, size: 35),
              ),
            ),
        ],
      ),
    );
  }
}