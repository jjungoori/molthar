import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/hostPage.dart';
class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Lobby Page'),
          if(GameServerController.to.started)
            ElevatedButton(
              onPressed: () {
                GameServerController.to.startGame();
                Get.toNamed('/game');
              },
              child: Text('게임 시작'),
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: GameServerController.to.server.connectedClients.keys.length,
            itemBuilder: (_, index){
              return Text(GameServerController.to.server.connectedClients.keys.toList()[index]);
            },
          )
        ],
      )
    );
  }
}
