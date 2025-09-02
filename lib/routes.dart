import 'package:flutter/material.dart';
import 'package:pet_network/home_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_network/main.dart';
import 'package:pet_network/view/camera/camera_screen.dart';
import 'package:pet_network/view/explorar.dart';
import 'package:pet_network/view/login/login_screen.dart';
import 'package:pet_network/view/my_home.dart';
import 'package:pet_network/view/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String explorar = '/explorar';
  static const String camera = '/camera';
  static const String homeapp = '/homeapp';



  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => LoginScreen(),
      home: (context) => const MyHomePage(),
      camera: (context) => Consumer( 
        builder: (context, ref, child) {
          return CameraScreen(cameras: ref.watch(camerasProvider).valueOrNull ?? []);
        }),
      splash: (context) => SplashScreen(),
      explorar: (context) => ExplorePage(),
      homeapp: (context) => HomeApp(),
    };
  }
}