
import 'dart:async';
import 'home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage(),
          ));
    });
  }

  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            height: 300,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 243, 241, 241)),
            width: double.infinity,
            child: Image.asset('./assets/mask.jpg'),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text(
            'MAsk Detection using tflite',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }
}
