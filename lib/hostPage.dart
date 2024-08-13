import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/gameServer.dart';

class HostPage extends StatelessWidget {
  const HostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Host Page'),
          ElevatedButton(
            onPressed: () {

            },
            child: Text('Back'),
          )
        ],
      )
    );
  }
}

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    var clientController = Get.put(ClientController());
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              clientController.joinServer();
            },
            child: Text('Join Server'),
          ),


          ElevatedButton(
            onPressed: () {
              Get.put(GameServerController());
              GameServerController.to.startServer();
            },
            child: Text('Open Server'),
          ),

        ],
      ),
    );
  }
}


class ClientController extends GetxController{
  // static ClientController get to => Get.find();
  var hostPage = HostPage().obs;

  void joinServer() async{
    // 호스트의 IP 주소와 포트 번호를 사용해 서버에 연결
    try {
      final String host = '127.0.0.1'; // 예: '192.168.0.10'
      final int port = 8080;

      Socket socket = await Socket.connect(host, port);
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // 서버에 플레이어 등록
      final registrationMessage = {
        'type': 'register',
        'player_id': 'player1'
      };
      socket.write(jsonEncode(registrationMessage));

      // 서버로부터의 메시지 수신 및 처리
      socket.listen(
            (data) async {
          final message = jsonDecode(utf8.decode(data));
          final type = message['type'];

          if (type == 'request_input') {
            print('Server: ${message['message']}');

            // 플레이어의 입력을 받음 (콘솔에서 입력받는 예시)
            print('Enter your guess (1-6):');
            int guessedNumber = int.parse(stdin.readLineSync()!);

            // 입력을 서버에 전송
            final playerInput = {
              'type': 'player_input',
              'player_id': 'player1',
              'guess': guessedNumber
            };
            socket.write(jsonEncode(playerInput));
          } else if (type == 'game_result') {
            print('Server: ${message['message']}');
          }
        },
        onDone: () {
          print('Server disconnected');
          socket.close();
        },
      );
    } catch (e) {
      print('Could not connect to server: $e');
    }
  }
}

class GameServerController extends GetxController{
  static GameServerController get to => Get.find();
  var hostPage = HostPage().obs;

  void startServer() async{
    // 서버를 시작하고 클라이언트의 연결을 대기
    final server = GameServer();
    await server.startServer(8080);
  }
}