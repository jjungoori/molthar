import 'package:get/get.dart';
import 'package:molthar/sysClasses.dart';

class GameController extends GetxController{
  static GameController get to => Get.find();
  var game = Game().obs;

  Map<String, int> userIDPlayerID = Map();

  var acts = [].obs;

  void resChange(){
    game.refresh();
    // setActs();
  }

  void initGame(){
    game.value = Game();
    game.value.init();
  }

  void startGame(){
    while(game.value.end == false){
      game.value.players[game.value.turnIndex];
    }
  }
}