import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/gamePage.dart';
import 'package:molthar/hostPage.dart';
import 'package:molthar/sysClasses.dart';
import 'package:molthar/utils.dart';

class SecretGameData {
  final List<int> hand;
  final List<String> activeActs;

  SecretGameData({
    required this.hand,
    required this.activeActs,
  });

  factory SecretGameData.fromJson(Map<String, dynamic> json) {
    return SecretGameData(
      hand: List<int>.from(json['data']['hand'] as List),
      activeActs: List<String>.from(json['data']['activeActs'] as List),
    );
  }
}

class SharingGameData {
  final int playerCount;
  final List<PlayerInfo> players;
  final int matDeckCount;
  final int characterDeckCount;
  final List<int> matField;
  final List<int> characterField;
  final int currentPlayerIndex;
  // final int remainingTurn;

  SharingGameData({
    required this.playerCount,
    required this.players,
    required this.matDeckCount,
    required this.characterDeckCount,
    required this.matField,
    required this.characterField,
    required this.currentPlayerIndex,
    // required this.remainingTurn,
  });

  factory SharingGameData.fromJson(Map<String, dynamic> json) {
    return SharingGameData(
      playerCount: (json['data']['playerCount'] as num).toInt(),
      players: (json['data']['players'] as List)
          .map((e) => PlayerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      matDeckCount: (json['data']['matDeckCount'] as num).toInt(),
      characterDeckCount: (json['data']['characterDeckCount'] as num).toInt(),
      matField: List<int>.from(json['data']['matField'] as List),
      characterField: List<int>.from(json['data']['characterField'] as List),
      currentPlayerIndex: (json['data']['currentPlayerIndex'] as num).toInt(),
      // remainingTurn: (json['data']['remainingTurn'] as num).toInt(),
    );
  }
}

class PlayerInfo {
  final int crystal;
  final int remainTurn;
  final int handCount;
  final int? gate1;
  final int? gate2;
  final List<int> openField;
  final int score;

  PlayerInfo({
    required this.crystal,
    required this.remainTurn,
    required this.handCount,
    this.gate1,
    this.gate2,
    required this.openField,
    required this.score,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
      crystal: json['crystal'],
      remainTurn: json['remainTurn'],
      handCount: json['handCount'],
      gate1: json['gate1'],
      gate2: json['gate2'],
      openField: List<int>.from(json['openField']),
      score: json['score'],
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

          ElevatedButton(
            onPressed: () {
              GameServerController.to.startGame();
            },
            child: Text('start'),
          ),

          GamePage()

        ],
      ),
    );
  }
}

class GamePageData{
  bool openFieldShowing = false;

  void toggleOpenField(){
    openFieldShowing = !openFieldShowing;
  }

  bool getOpenFieldShowing(){
    return openFieldShowing;
  }
}


class ClientController extends GetxController{
  static ClientController get to => Get.find();

  var gamePageData = GamePageData().obs;

  String id = utils.CreateCryptoRandomString(8);
  int index = 0;

  var started = false.obs;

  var selectedMaterials = <int>[].obs;
  var selectedCrystals = 0.obs;


  Socket? socket;

  // var hostPage = HostPage().obs;
  var cardData = {};
  var gameData = SharingGameData(
    playerCount: 0,
    players: [],
    matDeckCount: 0,
    characterDeckCount: 0,
    matField: [],
    characterField: [],
    currentPlayerIndex: 0,
    // remainingTurn: 0,
  ).obs;

  var secretGameData = SecretGameData(
    hand: [],
    activeActs: [],
  ).obs;

  void sendToServer(Map<String, dynamic> data, String type){
    socket!.write(jsonEncode({
      'player_id': id,
      'type': type,
      'data': data
    }));
  }

  PlayerInfo getCurrentPlayerInfo(){
    return gameData.value.players[index];
  }

  Future<void> joinServer() async{
    // 호스트의 IP 주소와 포트 번호를 사용해 서버에 연결
    try {
      final String host = '10.0.2.2'; // 예: '192.168.0.10'
      final int port = 8080;

      socket = await Socket.connect(host, port);

      print('Connected to: ${socket!.remoteAddress.address}:${socket!.remotePort}');

      // 서버에 플레이어 등록
      final registrationMessage = {
        'type': 'register',
        'player_id': id
      };
      socket!.write(jsonEncode(registrationMessage));

      // 서버로부터의 메시지 수신 및 처리
      socket!.listen(
            (data) async {
              // print("received data");

              String input = utf8.decode(data);

              List<String> parts = input.split('}{');

              // }{가 분리된 곳에 다시 붙여서 원래 형식으로 복원
              for (int i = 0; i < parts.length - 1; i++) {
                parts[i] = parts[i] + '}';
                parts[i + 1] = '{' + parts[i + 1];
              }

              // print(parts);

              for(var m in parts){
                final message = jsonDecode(m);

                final type = message['type'];
                if(type == 'start_notify'){
                  ClientController.to.started.value = true;
                  if(GameServerController.to.started == false){
                    Game().init();
                    Get.toNamed('/game');
                  }
                }
                if(type == 'set_index'){
                  index = message['data']['index'];
                  // print("received index");
                }
                if(type == 'card_data'){
                  cardData = message['data'];
                  // gameData.refresh();
                  // print("received card data");
                }
                if(type == 'game_view'){
                  gameData.value = SharingGameData.fromJson(message);
                  gameData.refresh();
                  // print("received game view data");
                }
                if(type == 'secret_view'){
                  secretGameData.value = SecretGameData.fromJson(message);
                  secretGameData.refresh();
                  // print("received secret game view data");
                }
                //
                // if (type == 'request_input') {
                //   print('Server: ${message['message']}');
                //
                //   // 플레이어의 입력을 받음 (콘솔에서 입력받는 예시)
                //   print('Enter your guess (1-6):');
                //   int guessedNumber = int.parse(stdin.readLineSync()!);
                //
                //   // 입력을 서버에 전송
                //   final playerInput = {
                //     'type': 'player_input',
                //     'player_id': 'player1',
                //     'guess': guessedNumber
                //   };
                //   socket.write(jsonEncode(playerInput));
                // } else if (type == 'game_result') {
                //   print('Server: ${message['message']}');
                // }
              }


        },
        onDone: () {
          print('Server disconnected');
          socket!.close();
        },
      );
    } catch (e) {
      print('Could not connect to server: $e');
    }
  }
}
