import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/actionButtons.dart';
import 'package:molthar/client.dart';
import 'package:molthar/gameController.dart';
import 'package:molthar/gamePage.dart';
import 'package:molthar/hostPage.dart';
import 'package:molthar/pages/lobbyPage.dart';
import 'package:molthar/pages/mainPage.dart';

void main() {
  Get.put(GameController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ClientController());
    Get.put(GameServerController());
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/lobby', page: () => const LobbyPage()),
        GetPage(name: '/game', page: () => GamePage()),
      ],
      home: MainPage(),
    );
  }
}
//
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TurnButtons(),
//     );
//   }
// }
