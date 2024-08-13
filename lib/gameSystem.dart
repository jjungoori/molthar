import 'dart:async';

import 'package:molthar/sysClasses.dart';

class GameSystem {
  final Game game;
  int currentPlayerIndex = 0;

  GameSystem(this.game);

  Player getCurrentPlayer() {
    return game.players[currentPlayerIndex];
  }

  Future<void> startGame() async {
    while (true) {
      var currentPlayer = getCurrentPlayer();
      // print('${currentPlayer.name}의 차례입니다.');
      //
      // // 서버에서 해당 플레이어에게 입력 요청
      // var guessedNumber = await requestPlayerInput(currentPlayer);
      //
      // // 주사위를 굴리고 결과 확인
      // int rolledNumber = game.rollDice();
      // bool correct = game.checkGuess(guessedNumber);
      //
      // print('${currentPlayer.name}이 ${guessedNumber}를 선택했습니다. 주사위 결과: ${rolledNumber}');
      //
      // if (correct) {
      //   print('${currentPlayer.name}이 맞췄습니다! 다시 시도하세요.');
      // } else {
      //   print('${currentPlayer.name}이 틀렸습니다. 다음 플레이어로 넘어갑니다.');
      //   currentPlayerIndex = (currentPlayerIndex + 1) % game.players.length;
      // }
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
