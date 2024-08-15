import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/gamePage.dart';
import 'package:molthar/gameServer.dart';
import 'package:molthar/gameSystem.dart';
import 'package:molthar/sysClasses.dart';

// class HostPage extends StatelessWidget {
//   const HostPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text('Host Page'),
//           ElevatedButton(
//             onPressed: () {
//
//             },
//             child: Text('Back'),
//           )
//         ],
//       )
//     );
//   }
// }


class GameServerController extends GetxController{
  static GameServerController get to => Get.find();
  // var hostPage = HostPage().obs;
  var server = GameServer();
  bool started = false;

  Future<void> startServer() async{
    // 서버를 시작하고 클라이언트의 연결을 대기
    await server.startServer(8080);
    started = true;
    return;
  }

  void startGame() async{
    // 게임을 시작하고 플레이어의 입력을 대기
    final game = Game();
    final gameSystem = GameSystem(game: game, server: server);

    gameSystem.initPlayers(server.connectedClients.keys.toList());

    await gameSystem.startGame();
  }
}