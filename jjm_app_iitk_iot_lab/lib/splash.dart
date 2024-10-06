import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'login.dart'; // Make sure to import your map.dart file correctly

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({Key? key}); // Adjusted constructor

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/Flow.json",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.75,
                fit: BoxFit.cover,
                animate: true,
                repeat: false,
              ),
            ],
          ),
        ),
      ),
      nextScreen: LoginPage(),
      splashIconSize: 400,
      backgroundColor: Color.fromARGB(255, 107, 81, 223),
    );
  }
}
