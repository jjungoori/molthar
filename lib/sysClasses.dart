import 'dart:math';

import 'package:flutter/material.dart';
import 'costDef.dart';

//히스토리 기록시, Act의 run이 History를 리턴하게

class Game{
  Deck matDeck = Deck(fieldCount: 4);
  Deck characterDeck = Deck(fieldCount: 2);
  List<Player> players = [];


  void init(){

    for(int i = 1; i <= 8; i++){
      for(int l = 0; l < 7; l++){
        matDeck.cards.add(Card(pos: 0, mat: i, resetCharacterField: (i==4||i==3||i==5) && l==0));
      }
    }
    matDeck.cards.shuffle(Random());
    matDeck.resetField();

    // for(int i = 0; i < 10; i++){
    //   characterDeck.cards.add(Card(pos: 0, character: Character(
    //     costs: n123,
    //     score: i,
    //     act: ResetMatField()
    //   )));
    // }
    characterDeck.cards = [
      Card(pos: 0,
        character: Character(
          costs: [
            Cost(mats: [1,1])
          ],
          score: 1,
          act: AddToAlways(mat: 1)
        )
      ),
      Card(pos: 0,
          character: Character(
              costs: same2,
              score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),

      Card(pos: 0,
          character: Character(
            costs: same2,
            score: 1,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same3,
            score: 2,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same4,
            score: 3,
          )
      ),
      Card(pos: 0,
          character: Character(
            costs: same2And66,
            score: 3,
            crystal: 1
          )
      )
    ];

    characterDeck.cards.shuffle(Random());
    characterDeck.resetField();

    for(int i = 0; i < 2; i++){
      players.add(Player(game: this));
    }
  }

// Field matField = Field();
// Field characterField = Field();
}

// class Field{
//   List<Card> cards = [];
//
//   Card takeAt(int index){
//     return cards.removeAt(index);
//   }
// }

//필드는 덱 안에 구현하기로

class Turn{
  String name = "NO NAME";

}

//Turn에서는 ㄹ
//행위는 Act

class ActResult{
  bool success;
  ActResult({
    this.success = true
  });
}

abstract class Act{
  ActResult run(Game game, Player? player, Player? target);
  String describe(Game game){
    return toString();
  }
}

class GetMatFromDeck extends Act{

  @override
  ActResult run(Game game, Player? player, Player? target){
    player!.hand.addMat(game.matDeck.take());
    player!.decreaseRemainTurn();
    return ActResult();
  }
}

class GetMatFromField extends Act{
  int index;
  GetMatFromField({
    required this.index
  });

  @override
  ActResult run(Game game, Player? player, Player? target){
    Card mat = game.matDeck.takeAtField(index);
    if(mat.resetCharacterField){
      ResetCharacterField().run(game, player, target);
    }
    player!.hand.addMat(mat);
    player!.decreaseRemainTurn();
    return ActResult();
  }

  @override
  String describe(Game game){
    return "Get ${index}nd card(${game.matDeck.field[index].mat!}) from field";
  }
}

class GetCharacterFromField extends Act{
  int index;
  GetCharacterFromField({
    required this.index
  });

  @override
  ActResult run(Game game, Player? player, Player? target){
    if(player!.gate.characters.length > 1){
      return ActResult(success: false);
    }
    player!.gate.addCharacter(game.characterDeck.takeAtField(index));
    player!.decreaseRemainTurn();
    return ActResult();
  }
}

class GetCharacterFromDeck extends Act{

  @override
  ActResult run(Game game, Player? player, Player? target){
    if(player!.gate.characters.length > 1){
      return ActResult(success: false);
    }
    player!.gate.addCharacter(game.characterDeck.take());
    player!.decreaseRemainTurn();
    return ActResult();
  }
}

class ResetMatField extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    game.matDeck.resetField();
    player!.decreaseRemainTurn();
    return ActResult();
  }
}

class SelectMaterial extends Act{
  SelectMaterial({
    required this.index
  });

  int index;

  @override
  ActResult run(Game game, Player? player, Player? target) {
    player!.SelectMatWithIndex(index);
    return ActResult();
  }

  @override
  String describe(Game game){
    return "Select ${index}nd mat()";
  }
}

bool isMadeable(Player player, Character character) {
  for (Cost cost in character.costs) {
    List<int> playerMats = player.hand.mats
        .where((card) => card.selected)
        .map((card) => card.mat)
        .whereType<int>()
        .toList();

    int availableCrystals = player.selectedCrystals;

    if (availableCrystals < cost.crystal) {
      continue;
    }

    playerMats += player.always;

    int remainingCrystals = availableCrystals - cost.crystal;

    List<int> requiredMats = List.from(cost.mats);

    bool canPurchase = true;
    for (int requiredMat in requiredMats) {
      int playerMatIndex = playerMats.indexOf(requiredMat);

      if (playerMatIndex != -1) {
        playerMats.removeAt(playerMatIndex);
      } else if (remainingCrystals > 0) {
        remainingCrystals--;
      } else {
        canPurchase = false;
        break;
      }
    }

    if (canPurchase) {
      return true;
    }
  }

  return false;
}
class Made extends Act{
  // List<Card> costs;
  // int crystal;
  int index;
  Made({
    // required this.costs,
    // required this.crystal,
    required this.index
  });
  @override
  ActResult run(Game game, Player? player, Player? target){
    Card targetCharacter = player!.gate.characters[index];
    if(!isMadeable(player, targetCharacter.character!)){
      print("not madeable");
      return ActResult(success: false);
    }
    for(int i = 0; i < player!.hand.mats.length; i++){
      if(player.hand.mats[i].selected){
        player.hand.mats.removeAt(i);
        i -= 1;
      }
    }
    player!.selectedCrystals = 0;
    player!.gate.characters.removeAt(index);
    player!.openField.characters.add(targetCharacter);
    if(targetCharacter.character!.act != null){
      targetCharacter.character!.act!.run(game, player, target);
    }
    player!.decreaseRemainTurn();

    return ActResult();
  }
}

class RestoreHand extends Act{
  List<Card> mats;

  RestoreHand({
    required this.mats
  });

  @override
  ActResult run(Game game, Player? player, Player? target) {
    for (int i = 0; i < mats.length; i++) {
      player!.hand.mats.remove(mats[i]);
    }
    for(int i = 0; i < mats.length; i++){
      player!.hand.addMat(game.matDeck.take());
    }
    return ActResult();
  }
}

class ResetCharacterField extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    game.characterDeck.resetField();
    return ActResult();
  }
}


class UseCrystal extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    if(player!.crystal>0){
      player!.crystal -= 1;
      player!.selectedCrystals += 1;
    }
    return ActResult();
  }
}

class UnUseCrystal extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    if(player!.selectedCrystals > 0){
      player!.selectedCrystals -= 1;
      player!.crystal += 1;
    }
    return ActResult();
  }
}
//<<<<<<<<<<<<<<<<<<<<<<<
class SeeOthersSelectMenu extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    for(int i = 0; i < game.players.length; i++){
      if(game.players[i] == player) {
        continue;
      }
      player!.activeActs.add(SeeOthersSelect(index: i));
    }
    return ActResult();
  }
}

class SeeOthersSelect extends Act{
  int index;
  SeeOthersSelect({
    required this.index
  });

  @override
  ActResult run(Game game, Player? player, Player? target){
    for(int i = 0; i < game.players[index].hand.mats.length; i++){
      SeeOthersSelectCard(index: index, index2: i);
    }
    return ActResult();
  }
}

class SeeOthersSelectCard extends Act{
  int index;
  int index2;

  SeeOthersSelectCard({
    required this.index,
    required this.index2
  });

  @override
  ActResult run(Game game, Player? player, Player? target){
    player!.hand.addMat(game.players[index].hand.mats.removeAt(index2));
    return ActResult();
  }

}
//>>>>>>>>>>>>>>>>>

class SeeTopOfDeck extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    print(game.characterDeck.cards[0]); //----------------------------------------
    return ActResult();
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class ChangeCharacterGateToField extends Act{
  @override
  ActResult run(Game game, Player? player, Player? target){
    player!.activeActs.add(ChangeCharacterGateToFieldSelectGate(indexOfGate: 0));
    player!.activeActs.add(ChangeCharacterGateToFieldSelectGate(indexOfGate: 1));
    player!.activeActs.add(ChangeCharacterGateToFieldSelectField(indexOfField: 0));
    player!.activeActs.add(ChangeCharacterGateToFieldSelectField(indexOfField: 1));
    player!.activeActs.add(ChangeCharacterGateToFieldFinal(indexOfGate: player.selectedGateIndex, indexOfField: player.selectedFieldIndex));
    return ActResult();
  }
}

class ChangeCharacterGateToFieldSelectGate extends Act{
  ChangeCharacterGateToFieldSelectGate({
    required this.indexOfGate
  });
  int indexOfGate;
  
  ActResult run(Game game, Player? player, Player? target) {
      player!.selectedGateIndex = indexOfGate;
      return ActResult();
  }
}

class ChangeCharacterGateToFieldSelectField extends Act{
  ChangeCharacterGateToFieldSelectField({
    required this.indexOfField
  });
  int indexOfField;

  ActResult run(Game game, Player? player, Player? target) {
    player!.selectedFieldIndex = indexOfField;
    return ActResult();
  }
}

class ChangeCharacterGateToFieldFinal extends Act{
  int indexOfGate;
  int indexOfField;

  ChangeCharacterGateToFieldFinal({
    required this.indexOfGate,
    required this.indexOfField
  });

  @override
  ActResult run(Game game, Player? player, Player? target) {
    var temp = player!.gate.characters[indexOfGate];
    player!.gate.characters[indexOfGate] = game.characterDeck.cards[indexOfField];
    game.characterDeck.cards[indexOfField] = temp;
    return ActResult();
  }
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// <<<<<<<<<<<<<<<<<<
class KillOthers extends Act{
  ActResult run(Game game, Player? player, Player? target) {
    for(int i = 0; i < game.players.length; i++){
      for(int l = 0; l < game.players[i].gate.characters.length; l++){
        player!.activeActs.add(KillOthersSelect(gateIndex: l, playerIndex: i));
      }
    }
    return ActResult();
  }
}

class KillOthersSelect extends Act {
  int playerIndex;
  int gateIndex;
  
  KillOthersSelect({
    required this.playerIndex,
    required this.gateIndex
  });
  
  ActResult run(Game game, Player? player, Player? target) {
    game.characterDeck.used.add(game.players[playerIndex].gate.characters.removeAt(gateIndex));
    return ActResult();
  }
}
// >>>>>>>>>>>

// <<<<<<<<<<<<<<<<<
class GetOneFromUsed3 extends Act {
  ActResult run(Game game, Player? player, Player? target) {
    player!.activeActs.add(GetOneFromUsed3Select(index: 0));
    player!.activeActs.add(GetOneFromUsed3Select(index: 1));
    player!.activeActs.add(GetOneFromUsed3Select(index: 2));
    return ActResult();
  }
}

class GetOneFromUsed3Select extends Act{
  int index;
  GetOneFromUsed3Select({
    required this.index
  });
  ActResult run(Game game, Player? player, Player? target) {
    // List<Card> used3 = [
    //   game.characterDeck.used[game.characterDeck.used.length-1],
    //   game.characterDeck.used[game.characterDeck.used.length-2],
    //   game.characterDeck.used[game.characterDeck.used.length-3]
    // ];
    player!.hand.addMat(game.characterDeck.used.removeAt(game.characterDeck.used.length-1-index));
    return ActResult();
  }
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class AddToAlways extends Act {
  int mat;

  AddToAlways({
    required this.mat
  });

  ActResult run(Game game, Player? player, Player? target) {
    player!.always.add(mat);
    return ActResult();
  }
}

class Deck{
  List<Card> cards = [];
  List<Card> used = [];
  List<Card> field = [];

  int fieldCount;

  Deck({required this.fieldCount});

  void restore(){
    if(cards.length > 0) {
      print("Error: restore는 cards가 비었을 때 실행되어야함.");
      return;
    }
    used.shuffle(Random());
    cards = List.from(used);
    used.clear();
  }

  Card take(){
    if(cards.length <= 0){
      restore();
    }
    return cards.removeAt(0);
  }

  Card takeAtField(int index){
    Card takenCard = Card.from(field[index]);
    Card newCard = take();
    newCard.pos = index;
    field[index] = newCard;
    return takenCard;
  }

  void resetField(){
    used += field;
    field.clear();
    for(int i = 0; i < fieldCount; i++){
      Card newCard = take();
      newCard.pos = i;
      field.add(take());
    }
  }
}


class Card{
  int pos = 0; //오픈 필드에서의 카드 위치
  int? mat;
  Character? character;
  bool resetCharacterField;
  bool selected = false;

  Card({
    required this.pos,

    this.mat,
    this.character,
    this.resetCharacterField = false
  });

  Card.from(Card card)
      :pos = card.pos,
        mat = card.mat,
        character = card.character,
    resetCharacterField = card.resetCharacterField;
}

class Player{
  Hand hand = Hand();//
  int crystal = 5;
  OpenField openField = OpenField();
  Gate gate = Gate();//
  Game game;//

  int remainTurn = 3;

  // List<Card> selectedCards = [];
  int selectedCrystals = 0;

  // List<Mat>

  List<Widget> autoActs = []; //-----------------------------------------------------------
  List<Act> activeActs = [];
  
  int selectedGateIndex = 0;
  int selectedFieldIndex = 0;

  List<int> always = [];

  Player({
    required this.game,
  });

  void SelectMatWithIndex(int index){
    hand.mats[index].selected = !hand.mats[index].selected;
  }

  void decreaseRemainTurn(){
    remainTurn -= 1;
  }


  List<Act> getAvailableActs(){
    if(remainTurn<1){
      return [];
    }
    List<Act> acts = [];
    acts.add(GetMatFromDeck());
    for(int i = 0; i < 4; i++){
      acts.add(GetMatFromField(index: i));
    }
    if(gate.characters.length < 2){
      acts.add(GetCharacterFromDeck());
      for(int i = 0; i < 2; i++){
        acts.add(GetCharacterFromField(index: i));
      }
    }
    acts.add(ResetMatField());
    // acts.add(Made(costs: costs, index: index))

    for(int i = 0; i < hand.mats.length; i++){
      acts.add(SelectMaterial(index: i));
    }

    for(int i = 0; i < gate.characters.length; i++){
      acts.add(Made(index: i));
    }

    acts.add(UnUseCrystal());
    acts.add(UseCrystal());

    acts += activeActs;
    return acts;
  }
}

class Gate{
  List<Card> characters = [];

  void addCharacter(Card character){
    characters.add(character);
  }
}

class OpenField{
  List<Card> characters = [];
}

class Hand{
  List<Card> mats = [];

  void addMat(Card card){
    mats.add(card);
  }
}

class Character{
  List<Cost> costs;
  int crystal;
  Act? act;
  int score;
  Character({
    required this.costs,
    required this.score,

    this.crystal = 0,
    this.act,
  });
}

class Cost{
  List<int> mats;
  int crystal;

  Cost({
    required this.mats,
    this.crystal = 0
  });

  String describe(){
    String res = "";
    for(int i = 0; i < mats.length; i++){
      res += mats[i].toString() + ", ";
    }
    res += 'and ${crystal} crystal';
    return res;
  }
}


//
// class Mat{
//   Mat({
//     required this.type
//   });
//
//   int type;
// }

// List<List<int>> findCombinations(int m, {int n = -1}) {
//   List<List<int>> result = [];
//
//   void backtrack(List<int> current, int remainingSum, int start) {
//     if (n != -1 && current.length > n) return;
//
//     if (remainingSum == 0 && (n == -1 || current.length == n)) {
//       result.add(List.from(current));
//       return;
//     }
//
//     if (remainingSum < 0) return;
//
//     for (int i = start; i <= 8; i++) {
//       current.add(i);
//       backtrack(current, remainingSum - i, i);
//       current.removeLast();
//     }
//   }
//
//   backtrack([], m, 1);
//   return result;
// }
