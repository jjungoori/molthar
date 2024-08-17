import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:molthar/gameSystem.dart';
import 'package:molthar/sysClasses.dart';


class GameServer {
  ServerSocket? serverSocket;
  Map<String, Socket> connectedClients = {}; // 각 플레이어의 소켓을 관리

  Map<String, String> messages = {};


  Future<void> startServer(int port) async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server running on port $port');

    serverSocket!.listen((client) {
      handleConnection(client);
    });
  }
  Map<String, Completer<Map<String, dynamic>>> pendingRequests = {}; // 플레이어 ID별로 응답을 기다리는 Completer 맵

  Future<Map<String, dynamic>> requestAndWaitForResponse(String playerId, Map<String, dynamic> data) async {

    sendToPlayer(playerId, data, 'data');

    // 클라이언트의 응답을 기다림
    Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();
    pendingRequests[playerId] = completer;

    // 응답을 기다림
    return completer.future;
  }

  void handleConnection(Socket client) {
    print('Client connected: ${client.remoteAddress.address}');

    // 클라이언트로부터 데이터를 받는 스트림 리스너
    client.listen(
          (data) {
            String input = utf8.decode(data);

            List<String> parts = input.split('}{');

            // }{가 분리된 곳에 다시 붙여서 원래 형식으로 복원
            for (int i = 0; i < parts.length - 1; i++) {
              parts[i] = parts[i] + '}';
              parts[i + 1] = '{' + parts[i + 1];
            }
            for(var m in parts){
              final message = jsonDecode(m);
              final type = message['type'];

              if (type == 'register') {
                final playerId = message['player_id'];
                connectedClients[playerId] = client;
                sendToPlayer(playerId, {
                  'index': connectedClients.length - 1,
                }, 'set_index');
                print('Player $playerId registered with server.');
                shootMessages();
              } else if (type == 'player_input') {
                handlePlayerInput(message);
              } else if (type == 'data_response') {
                // 클라이언트의 응답 처리
                final playerId = message['player_id'];
                if (pendingRequests.containsKey(playerId)) {
                  pendingRequests[playerId]!.complete(message['data']);
                  pendingRequests.remove(playerId); // 완료된 요청은 맵에서 제거
                }
              }
            };
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
    // 플레이어 입력 처리 로직
    final playerId = message['player_id'];
    final input = message['input'];

    // 예시로 입력을 처리
    print('Received input from player $playerId: $input');
    // 실제 게임 로직을 여기서 구현
  }

  //
  // void handlePlayerInput(Map<String, dynamic> message) {
  //   final playerId = message['player_id'];
  //   final guessedNumber = message['guess'];
  //
  //   print('Player $playerId guessed: $guessedNumber');
  //
  //   // 주사위를 굴리고 결과 확인
  //   int rolledNumber = Random().nextInt(6) + 1;
  //   bool correct = guessedNumber == rolledNumber;
  //
  //   // 결과를 클라이언트에 전송
  //   final result = {
  //     'type': 'game_result',
  //     'rolled_number': rolledNumber,
  //     'correct': correct,
  //     'message': correct
  //         ? 'Correct! The dice rolled $rolledNumber. Your turn again.'
  //         : 'Incorrect! The dice rolled $rolledNumber. Next player\'s turn.'
  //   };
  //
  //   connectedClients[playerId]?.write(jsonEncode(result));
  // }

  // 특정 플레이어에게 입력 요청을 보내는 함수
  void requestPlayerInput(String playerId) {

    sendToPlayer(playerId, {}, 'request_input');
  }
  //
  // Future<String> requestAndWaitForResponse(String playerId, Map<String, dynamic> data) async {
  //   Socket client = connectedClients[playerId]!;
  //
  //   // 클라이언트에게 요청을 보냄
  //   final requestMessage = {
  //     'type': 'data',
  //     'data': data
  //   };
  //
  //   client.write(jsonEncode(requestMessage));
  //
  //   // 클라이언트의 응답을 기다림
  //   Completer<String> completer = Completer<String>();
  //   client.listen((data) {
  //     String response = String.fromCharCodes(data).trim();
  //     completer.complete(response);
  //   });
  //
  //   // 응답을 기다림
  //   return completer.future;
  // }
  //
  // Future<void> sendToPlayer(String playerId, Map<String, dynamic> data, String type) async{
  //   final requestMessage = {
  //     'type': type,
  //     'data': data
  //   };
  //
  //   connectedClients[playerId]?.write(jsonEncode(requestMessage));
  //   await connectedClients[playerId]?.flush().then((value){return;});
  // }


  Future<void> sendToPlayer(String playerId, Map<String, dynamic> data, String type) async {

    messages[playerId] = (messages[playerId] ?? '') + jsonEncode({
      'type': type,
      'data': data,
    });
  }

  Future<void> shootMessages() async {
    for(var playerId in messages.keys){
      final socket = connectedClients[playerId];
      if (socket == null) {
        print('Player $playerId not connected');
        return;
      }

      try {
        final encodedMessage = utf8.encode(messages[playerId]!);
        await socket.addStream(Stream.fromIterable([encodedMessage]));
        messages[playerId] = '';
      } catch (e) {
        print('Error sending message to player $playerId: $e');
        // 에러 처리: 연결 해제 또는 재연결 시도 등
      }
    }
  }

  // Future<void> sendToPlayer(String playerId, Map<String, dynamic> data, String type) async {
  //   final socket = connectedClients[playerId];
  //   if (socket == null) {
  //     print('Player $playerId not connected');
  //     return;
  //   }
  //
  //   try {
  //     Map<String, dynamic> message = {
  //       'type': type,
  //       'data': data,
  //     };
  //     print('Sending message to player $playerId: $message');
  //     final encodedMessage = jsonEncode(message);
  //     await socket.addStream(Stream.fromIterable([utf8.encode(encodedMessage)]));
  //   } catch (e) {
  //     print('Error sending message to player $playerId: $e');
  //     // 에러 처리: 연결 해제 또는 재연결 시도 등
  //   }
  // }
}

