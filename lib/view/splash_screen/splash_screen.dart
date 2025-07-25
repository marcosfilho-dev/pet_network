import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_network/view/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: 
    Center(
      child: Image.asset("assets/images/logo.png")
      //LottieBuilder.asset("assets/images/logo.png"),
      ),
      nextScreen: LoginScreen(),
    splashIconSize: 400,
    backgroundColor: Colors.white,
    splashTransition: SplashTransition.scaleTransition,
    curve: Curves.elasticOut,
    duration: 3000,
    )
    ;
  
    
  }
}