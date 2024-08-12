import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/actionButtons.dart';
import 'package:molthar/gameController.dart';
import 'package:molthar/gamePage.dart';

void main() {
  Get.put(GameController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: GamePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TurnButtons(),
    );
  }
}
