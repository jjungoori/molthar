import 'package:get/get.dart';
import 'package:molthar/sysClasses.dart';

class GameController extends GetxController{
  static GameController get to => Get.find();
  var game = Game().obs;

  var acts = [].obs;

  void resChange(){
    game.refresh();
    setActs();
  }

  void initGame(){
    game.value = Game();
    game.value.init();
  }

  void setActs(){
    acts.value = game.value.players[0].getAvailableActs();
  }
}