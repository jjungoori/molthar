import 'dart:async';
import 'dart:convert';

import 'package:molthar/gameServer.dart';
import 'package:molthar/sysClasses.dart';

class GameViewData {
  final Game game;

  GameViewData({required this.game});

  Map<String, dynamic> secretJson(Player player){
    Map<String, dynamic> playerSelfInfo(){
      return {
        'hand': player.hand.mats.map((e) => e.mat).toList(),
        'activeActs': player.activeActs.map((e) => e.runtimeType.toString()).toList(),
      };
    }

    return playerSelfInfo();
  }

  Map<String, dynamic> viewJson() {
    Map<String, dynamic> playerViewInfo(Player player) {
      return {
        'crystal':player.crystal,
        'remainTurn': player.remainTurn,
        'handCount': player.hand.mats.length,
        'gate1': player.gate.characters.length > 0 ? player.gate.characters[0].id : null,
        'gate2': player.gate.characters.length > 1 ? player.gate.characters[0].id : null,
        'openField': player.openField.characters.map((e) => e.id).toList(),
        'score': player.score,
      };
    }


    return {
      'playerCount': game.players.length,
      'players': game.players.map((e) => playerViewInfo(e)).toList(),
      'matDeckCount': game.matDeck.cards.length,
      'characterDeckCount': game.characterDeck.cards.length,
      'matField': game.matDeck.field.map((e) => e.mat).toList(),
      'characterField': game.characterDeck.field.map((e) => e.id).toList(),
      // 'playerSelf': playerSelfInfo(),
      'currentPlayerIndex': game.turnIndex,
      'remainingTurn': game.players[game.turnIndex].remainTurn,
    };
  }
}

class GameSystem {
  final Game game;
  final GameServer server;
  // int currentPlayerIndex = 0;
  GameViewData gameViewData;

  GameSystem({
    required this.game,
    required this.server
  }) : gameViewData = GameViewData(game: game) {
    // server.startServer(8080);
  }

  void initPlayers(List<String> playerIds){
    for(var playerId in playerIds){
      game.players.add(Player(game: game, uid: playerId));
    }
  }

  Future<Map<String, dynamic>> waitForPlayerInput(Player player) async {
    var a = await server.requestAndWaitForResponse(player.uid, {'type': 'request_input'});
    return a;
  }
  Future<void> sendToPlayer(Player player, Map<String, dynamic> data, String type) async {
    await server.sendToPlayer(player.uid, data, type);
  }


  Player getCurrentPlayer() {
    return game.players[game.turnIndex];
  }

  Future<void> shareGameData() async {
    var data = gameViewData.viewJson();
    await Future.delayed(Duration(milliseconds: 100));

    for(var player in game.players){
      await sendToPlayer(player, data, 'game_view');
    }
    await Future.delayed(Duration(milliseconds: 100));
    for(var player in game.players){
      await sendToPlayer(player, gameViewData.secretJson(player), 'secret_view');
      print('sendSecret  to ${player.uid}');
    }
  }

  Future<void> playEachTurn() async {
    var currentPlayer = getCurrentPlayer();
    currentPlayer.remainTurn = currentPlayer.maxTurn;
    for(; currentPlayer.remainTurn > 0;){
      currentPlayer.setAvailableActs();
      // for(var player in game.players){
      //   await sendToPlayer(player, {'cards':Card.allCards}, 'card_data');
      // }
      // await Future.delayed(Duration(milliseconds: 100));

      await shareGameData();

      print("currentPlayer: ${currentPlayer.uid}");
      await Future.delayed(Duration(milliseconds: 100));
      Map<String, dynamic> input = await waitForPlayerInput(currentPlayer);
      print("getinput");
      handleInput(input, currentPlayer);

      await shareGameData();

      print('remainTurn: ${currentPlayer.remainTurn}');

      // game.acts[input['act']].run(game, game.players[0], game.players[1]);
    }
  }

  void handleInput(Map<String, dynamic> input, Player player){

    print(input);
    player.executeAct(game, null, input);
  }

  Future<void> startGame() async {
    game.init();
    for(var player in game.players){
      sendToPlayer(player, {}, 'start_notify');
    }

    while (true) {
      var currentPlayer = getCurrentPlayer();

      await playEachTurn();

    }
  }

  Future<int> requestPlayerInput(Player player) async {
    // 서버가 해당 플레이어에게 입력을 요청하고 응답을 기다리는 로직
    // 실제 네트워크 상에서의 구현은 서버가 플레이어 클라이언트와의 통신을 통해 수행됩니다.
    // 여기서는 단순히 사용자 입력을 대기하는 식으로 구현하겠습니다.
    Completer<int> completer = Completer<int>();

    // 이 부분은 서버와의 통신으로 대체될 수 있습니다.
    // 예를 들어 서버가 클라이언트로부터 숫자를 받을 때까지 대기하는 코드로 수정될 수 있습니다.
    print('플레이어 ${player.uid}, 1-6 사이의 숫자를 입력하세요:');
    // 여기서 실제 클라이언트로부터 응답을 기다리는 로직을 작성할 수 있습니다.
    // ex) 서버가 특정 포트에서 해당 클라이언트의 응답을 받을 때까지 기다리는 코드

    return completer.future;
  }
}
