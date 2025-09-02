
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/app_router.dart';
import 'package:pet_network/view/perfil.dart';

 
// Usar um FutureProvider é a forma idiomática e segura de lidar com
// inicializações assíncronas. O Riverpod gerenciará os estados de
// carregamento, erro e dados para você em toda a aplicação.
final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  return availableCameras();
});

Future<void> main() async {
  // Garante que os bindings do Flutter foram inicializados antes de rodar o app.
  WidgetsFlutterBinding.ensureInitialized();
  // O ProviderScope habilita o Riverpod para todo o aplicativo.
  // A busca pelas câmeras agora é gerenciada pelo `camerasProvider`.
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      title: 'PetSocial',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blueAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
    );
  }
}
