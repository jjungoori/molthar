import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:molthar/gameSystem.dart';
import 'package:molthar/sysClasses.dart';


class GameServer {
  ServerSocket? serverSocket;
  Map<String, Socket> connectedClients = {}; // 각 플레이어의 소켓을 관리

  Future<void> startServer(int port) async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server running on port $port');

    serverSocket!.listen((client) {
      handleConnection(client);
    });
  }

  void handleConnection(Socket client) {
    print('Client connected: ${client.remoteAddress.address}');

    // 클라이언트로부터 처음 연결 시 플레이어 ID를 받아 저장
    client.listen(
          (data) {
        final message = jsonDecode(utf8.decode(data));
        final type = message['type'];

        if (type == 'register') {
          final playerId = message['player_id'];
          connectedClients[playerId] = client;
          print('Player $playerId registered with server.');
        } else if (type == 'player_input') {
          handlePlayerInput(message);
        }
      },
      onDone: () {
        final player = connectedClients.entries.firstWhere(
              (entry) => entry.value == client,
          orElse: () => MapEntry('unknown', client),
        );
        print('Player ${player.key} disconnected: ${client.remoteAddress.address}');
        connectedClients.remove(player.key);
        client.close();
      },
    );
  }

  void handlePlayerInput(Map<String, dynamic> message) {
    final playerId = message['player_id'];
    final guessedNumber = message['guess'];

    print('Player $playerId guessed: $guessedNumber');

    // 주사위를 굴리고 결과 확인
    int rolledNumber = Random().nextInt(6) + 1;
    bool correct = guessedNumber == rolledNumber;

    // 결과를 클라이언트에 전송
    final result = {
      'type': 'game_result',
      'rolled_number': rolledNumber,
      'correct': correct,
      'message': correct
          ? 'Correct! The dice rolled $rolledNumber. Your turn again.'
          : 'Incorrect! The dice rolled $rolledNumber. Next player\'s turn.'
    };

    connectedClients[playerId]?.write(jsonEncode(result));
  }

  // 특정 플레이어에게 입력 요청을 보내는 함수
  void requestPlayerInput(String playerId) {
    final requestMessage = {
      'type': 'request_input',
      'message': 'Your turn! Please enter a number between 1 and 6.'
    };

    connectedClients[playerId]?.write(jsonEncode(requestMessage));
  }
}
