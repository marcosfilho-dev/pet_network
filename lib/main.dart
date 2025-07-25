
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pet_network/routes.dart';
 
late List<CameraDescription> cameras;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetSocial',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blueAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
