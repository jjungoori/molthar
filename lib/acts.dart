// import 'package:flutter/material.dart';
import 'package:molthar/sysClasses.dart';

class ActResult{
  bool success;
  ActResult({
    this.success = true
  });
}
//
// abstract class Act{
//   ActResult run(Game game, Player? player, Player? target);
//   String describe(Game game){
//     return toString();
//   }
// }
//
// class GetMatFromDeck extends Act{
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     player!.hand.addMat(game.matDeck.take());
//     player!.decreaseRemainTurn();
//     return ActResult();
//   }
// }
//
// class GetMatFromField extends Act{
//   int index;
//   GetMatFromField({
//     required this.index
//   });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     ResourceCard mat = game.matDeck.takeAtField(index);
//     if(mat.resetCharacterField){
//       ResetCharacterField().run(game, player, target);
//     }
//     player!.hand.addMat(mat);
//     player!.decreaseRemainTurn();
//     return ActResult();
//   }
//
//   @override
//   String describe(Game game){
//     return "Get ${index}nd card(${(game.matDeck.field[index]).mat}) from field";
//   }
// }
//
// class GetCharacterFromField extends Act{
//   int index;
//   GetCharacterFromField({
//     required this.index
//   });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     if(player!.gate.characters.length > 1){
//       return ActResult(success: false);
//     }
//     player!.gate.addCharacter(game.characterDeck.takeAtField(index));
//     player!.decreaseRemainTurn();
//     return ActResult();
//   }
// }
//
// class GetCharacterFromDeck extends Act{
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     if(player!.gate.characters.length > 1){
//       return ActResult(success: false);
//     }
//     player!.gate.addCharacter(game.characterDeck.take());
//     player!.decreaseRemainTurn();
//     return ActResult();
//   }
// }
//
// class ResetMatField extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     game.matDeck.resetField();
//     player!.decreaseRemainTurn();
//     return ActResult();
//   }
// }
//
// class Made extends Act{
//   // List<Card> costs;
//   // int crystal;
//   int id;
//   Made({
//     // required this.costs,
//     // required this.crystal,
//     required this.id
//   });
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     var targetCharacter = player!.gate.findCharacter(id);
//     if(!isMadeable(player, (targetCharacter!.card as CharacterCard).character)){
//       print("not madeable");
//       return ActResult(success: false);
//     }
//     for(int i = 0; i < player!.hand.mats.length; i++){
//       if(player.selectedMaterialCard.contains(player.hand.mats[i].mat)){
//         player.hand.mats.removeAt(i);
//         i -= 1;
//       }
//     }
//     player!.selectedCrystals = 0;
//     player!.gate.characters.removeAt(targetCharacter.index);
//     player!.openField.characters.add(targetCharacter.card.clone() as CharacterCard);
//     if((targetCharacter.card as CharacterCard).character.act != null){
//       (targetCharacter.card as CharacterCard).character.act!.run(game, player, target);
//     }
//     player!.decreaseRemainTurn();
//
//     return ActResult();
//   }
// }
//
// class RestoreHand extends Act{
//   List<Card> mats;
//
//   RestoreHand({
//     required this.mats
//   });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target) {
//     for (int i = 0; i < mats.length; i++) {
//       player!.hand.mats.remove(mats[i]);
//     }
//     for(int i = 0; i < mats.length; i++){
//       player!.hand.addMat(game.matDeck.take());
//     }
//     return ActResult();
//   }
// }
//
// class ResetCharacterField extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     game.characterDeck.resetField();
//     return ActResult();
//   }
// }
//
//
// class UseCrystal extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     if(player!.crystal>0){
//       player!.crystal -= 1;
//       player!.selectedCrystals += 1;
//     }
//     return ActResult();
//   }
// }
//
// class UnUseCrystal extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     if(player!.selectedCrystals > 0){
//       player!.selectedCrystals -= 1;
//       player!.crystal += 1;
//     }
//     return ActResult();
//   }
// }
// //<<<<<<<<<<<<<<<<<<<<<<<
// class SeeOthersSelectMenu extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     for(int i = 0; i < game.players.length; i++){
//       if(game.players[i] == player) {
//         continue;
//       }
//       player!.activeActs.add(SeeOthersSelect(index: i));
//     }
//     return ActResult();
//   }
// }
//
// class SeeOthersSelect extends Act{
//   int index;
//   SeeOthersSelect({
//     required this.index
//   });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     for(int i = 0; i < game.players[index].hand.mats.length; i++){
//       SeeOthersSelectCard(index: index, index2: i);
//     }
//     return ActResult();
//   }
// }
//
// class SeeOthersSelectCard extends Act{
//   int index;
//   int index2;
//
//   SeeOthersSelectCard({
//     required this.index,
//     required this.index2
//   });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     player!.hand.addMat(game.players[index].hand.mats.removeAt(index2));
//     return ActResult();
//   }
//
// }
// //>>>>>>>>>>>>>>>>>
//
// class SeeTopOfDeck extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     print(game.characterDeck.cards[0]); //----------------------------------------
//     return ActResult();
//   }
// }
//
//
// class ChangeCharacterGateToFieldFinal extends Act{
//   // int indexOfGate;
//   // int indexOfField;
//   //
//   // ChangeCharacterGateToFieldFinal({
//   //   // required this.indexOfGate,
//   //   // required this.indexOfField
//   // });
//
//   @override
//   ActResult run(Game game, Player? player, Player? target) {
//     var gateCard = player!.gate.findCharacter(player.selectedGateCard[0]);
//     var fieldCard = game.characterDeck.findCard(player.selectedGateCard[0]);
//     player.gate.characters[gateCard!.index] = fieldCard!.card.clone() as CharacterCard;
//     game.characterDeck.cards[fieldCard.index] = gateCard.card.clone() as CharacterCard;
//     return ActResult();
//   }
// }
//
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
// // <<<<<<<<<<<<<<<<<<
// // class KillOthers extends Act{
// //   ActResult run(Game game, Player? player, Player? target) {
// //     for(int i = 0; i < game.players.length; i++){
// //       for(int l = 0; l < game.players[i].gate.characters.length; l++){
// //         player!.activeActs.add(KillOthersSelect(gateIndex: l, playerIndex: i));
// //       }
// //     }
// //     return ActResult();
// //   }
// // }
//
// class KillOthersSelect extends Act {
//   // int playerIndex;
//   int id;
//
//   KillOthersSelect({
//     // required this.playerIndex,
//     required this.id
//   });
//
//   ActResult run(Game game, Player? player, Player? target) {
//     // game.characterDeck.used.add(game.players[playerIndex].gate.characters.removeAt(gateIndex));
//     for(int i = 0; i < game.players.length; i++){
//       var f = game.players[i].gate.findCharacter(id);
//       if(f != null){
//         game.players[i].gate.characters.removeAt(f.index);
//         game.characterDeck.used.add(f.card as CharacterCard);
//         return ActResult();
//       }
//     }
//     return ActResult();
//   }
// }
// // >>>>>>>>>>>
//
// // <<<<<<<<<<<<<<<<<
// // class GetOneFromUsed3 extends Act {
// //   ActResult run(Game game, Player? player, Player? target) {
// //     player!.activeActs.add(GetOneFromUsed3Select(index: 0));
// //     player!.activeActs.add(GetOneFromUsed3Select(index: 1));
// //     player!.activeActs.add(GetOneFromUsed3Select(index: 2));
// //     return ActResult();
// //   }
// // }
//
// class GetOneFromUsed3Select extends Act{
//   int id;
//   GetOneFromUsed3Select({
//     required this.id
//   });
//   ActResult run(Game game, Player? player, Player? target) {
//     // List<Card> used3 = [
//     //   game.characterDeck.used[game.characterDeck.used.length-1],
//     //   game.characterDeck.used[game.characterDeck.used.length-2],
//     //   game.characterDeck.used[game.characterDeck.used.length-3]
//     // ];
//     player!.hand.addMat(game.matDeck.used.removeAt(game.matDeck.findCardInUsed(id)!.index));
//     return ActResult();
//   }
// }
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
// class AddToAlways extends Act {
//   int mat;
//
//   AddToAlways({
//     required this.mat
//   });
//
//   ActResult run(Game game, Player? player, Player? target) {
//     player!.always.add(mat);
//     return ActResult();
//   }
// }
//
//


abstract class Act {
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters);
}

class GetMatFromDeck extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    player!.hand.addMat(game.matDeck.take());
    player.decreaseRemainTurn();
    return ActResult();
  }
}

class GetMatFromField extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    ResourceCard mat = game.matDeck.takeAtField(index, game);
    if (mat.resetCharacterField) {
      ResetCharacterField().run(game, player, target, {});
    }
    player!.hand.addMat(mat);
    player.decreaseRemainTurn();
    return ActResult();
  }
}

class GetCharacterFromField extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    if (player!.gate.characters.length > 1) {
      return ActResult(success: false);
    }
    player.gate.addCharacter(game.characterDeck.takeAtField(index, game));
    player.decreaseRemainTurn();
    return ActResult();
  }
}

class GetCharacterFromDeck extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    if (player!.gate.characters.length > 1) {
      return ActResult(success: false);
    }
    player.gate.addCharacter(game.characterDeck.take());
    player.decreaseRemainTurn();
    return ActResult();
  }
}

class ResetMatField extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    game.matDeck.resetField(game);
    player!.decreaseRemainTurn();
    return ActResult();
  }
}

class Made extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {

    if(player!.crystal < parameters['crystal']){
      return ActResult(success: false);
    }

    player!.selectedCrystals = parameters['crystal'];
    player.selectedMaterialCard = [for(int i = 0; i < parameters['materials'].length; i++) player.hand.mats[parameters['materials'].cast<int>()[i]].mat];

    // print("materialCard: ${player.selectedMaterialCard}");

    int index = parameters['index'];
    Card targetCharacter = player!.gate.characters[index];
    if (!isMadeable(player, (targetCharacter as CharacterCard).character)) {
      // print("not madeable");
      return ActResult(success: false);
    }
    player.hand.mats.removeWhere((mat) => player.selectedMaterialCard.contains(mat.mat));
    // player.selectedCrystals = 0;
    player.crystal -= player.selectedCrystals;
    player.gate.characters.removeAt(index);
    player.openField.characters.add(targetCharacter.clone() as CharacterCard);
    if ((targetCharacter as CharacterCard).character.act != null) {
      (targetCharacter as CharacterCard).character.act!.run(game, player, target, {});
    }
    player.decreaseRemainTurn();
    // print('made suc');
    return ActResult();
  }
}

class RestoreHand extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    List<Card> mats = parameters['mats'];
    for (var mat in mats) {
      player!.hand.mats.remove(mat);
    }
    for (var mat in mats) {
      player!.hand.addMat(game.matDeck.take());
    }
    return ActResult();
  }
}

class ResetCharacterField extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    game.characterDeck.resetField(game);
    return ActResult();
  }
}

// class UseCrystal extends Act {
//   @override
//   ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
//     if (player!.crystal > 0) {
//       player.crystal -= 1;
//       player.selectedCrystals += 1;
//     }
//     return ActResult();
//   }
// }
//
// class UnUseCrystal extends Act {
//   @override
//   ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
//     if (player!.selectedCrystals > 0) {
//       player.selectedCrystals -= 1;
//       player.crystal += 1;
//     }
//     return ActResult();
//   }
// }

// class SeeOthersSelectMenu extends Act {
//   @override
//   ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
//     for (int i = 0; i < game.players.length; i++) {
//       if (game.players[i] == player) {
//         continue;
//       }
//       // player!.activeActs.add(SeeOthersSelect(index: i));
//       player!.addAct(SeeOthersSelect(target)))
//     }
//     return ActResult();
//   }
// }

class SeeOthersSelect extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    // for (int i = 0; i < game.players[index].hand.mats.length; i++) {
    //   SeeOthersSelectCard().run(game, player, target, {'index': index, 'index2': i});
    // }
    player!.addAct(SeeOthersSelectCard(targetPlayerIndex: index));
    return ActResult();
  }
}

class SeeOthersSelectCard extends Act {

  int targetPlayerIndex = 0;

  SeeOthersSelectCard({required this.targetPlayerIndex});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    // int index2 = parameters['index2'];
    player!.hand.addMat(game.players[targetPlayerIndex].hand.mats.removeAt(index));
    return ActResult();
  }
}

class SeeTopOfDeck extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // print(game.characterDeck.cards[0]);
    return ActResult();
  }
}

class ChangeCharacterGateToFieldFinal extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int indexOfGate = parameters['indexOfGate'];
    int indexOfField = parameters['indexOfField'];
    var gateCard = player!.gate.characters[indexOfGate];
    var fieldCard = game.characterDeck.cards[indexOfField];
    player.gate.characters[indexOfGate] = fieldCard.clone() as CharacterCard;
    game.characterDeck.cards[indexOfField] = gateCard.clone() as CharacterCard;
    return ActResult();
  }
}

class KillOthersSelect extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    for (int i = 0; i < game.players.length; i++) {
      var f = game.players[i].gate.characters[index];
      if (f != null) {
        game.players[i].gate.characters.removeAt(index);
        game.characterDeck.used.add(f as CharacterCard);
        return ActResult();
      }
    }
    return ActResult();
  }
}

class GetOneFromUsed3Select extends Act {
  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    int index = parameters['index'];
    player!.hand.addMat(game.matDeck.used.removeAt(index));
    return ActResult();
  }
}

class AddToAlways extends Act {
  int mat;

  AddToAlways({required this.mat});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    if(mat==0){
      for(int i = 1; i < 9; i++){
        player!.always.add(i);
      }
      return ActResult();
    }
    player!.always.add(mat);
    return ActResult();
  }
}




class AddSpecialPassive extends Act {
  String id;

  AddSpecialPassive({required this.id});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    player!.specialPassives.add(id);
    return ActResult();
  }
}

class AddInstantMove extends Act {
  int amount;

  AddInstantMove({required this.amount});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    player!.instantTurn += amount;
    return ActResult();
  }
}

class AddInstantMoveToNext extends Act {
  int amount;

  AddInstantMoveToNext({required this.amount});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    game.players[(game.players.indexOf(player!)+1)%game.players.length].instantTurn += amount;
    return ActResult();
  }
}

class AddMove extends Act {
  int amount;

  AddMove({required this.amount});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    player!.maxTurn += amount;
    return ActResult();
  }
}

class SetRequestedAct extends Act {
  Act act;

  SetRequestedAct({required this.act});

  @override
  ActResult run(Game game, Player? player, Player? target, Map<String, dynamic> parameters) {
    // int mat = parameters['mat'];
    player!.requestedAct.add(act);
    return ActResult();
  }
}
