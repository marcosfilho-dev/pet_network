import 'package:flutter/material.dart';
import 'package:pet_network/main.dart';
import 'package:pet_network/view/camera/camera_screen.dart';
import 'package:pet_network/view/login/login_screen.dart';
import 'package:pet_network/view/my_home.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String camera = '/camera';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => LoginScreen(),
      home: (context) => const MyHomePage(),
      camera: (context) => CameraScreen(cameras: cameras),
    };
  }
}