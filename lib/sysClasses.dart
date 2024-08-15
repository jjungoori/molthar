import 'dart:convert';
import 'dart:math';

// import 'package:flutter/material.dart';
import 'package:molthar/acts.dart';
import 'package:molthar/gamePage.dart';
import 'costDef.dart';

//히스토리 기록시, Act의 run이 History를 리턴하게
abstract class Card {
  static int idCounter = 0;
  static Map<int, Card> allCards = {};
  final int id;

  // Constructor that assigns an ID based on the idCounter,
  // increments it, and adds the card to the static list
  Card() : id = idCounter++ {
    allCards[id] = this;
  }

  // Prototype pattern: each card knows how to clone itself
  Card clone();

  // Position setting method. Implemented in ResourceCard
  Card setPosition(int pos) => this;

// Factory constructor
// factory Card.createNew() {
//   throw UnimplementedError('Subclasses should implement createNew');
// }
}

class Game{
  Deck<ResourceCard> matDeck = Deck<ResourceCard>(fieldCount: 4);
  Deck<CharacterCard> characterDeck = Deck<CharacterCard>(fieldCount: 2);
  List<Player> players = [];

  bool end = false;

  int turnIndex = 0;

  // Game({required this.players});


  void init(){

    for(int i = 1; i <= 8; i++){
      for(int l = 0; l < 7; l++){
        matDeck.cards.add(ResourceCard(mat: i, resetCharacterField: (i==4||i==3||i==5) && l==0));
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
      CharacterCard(
        character: Character(
          costs: [
            Cost(mats: [1,1])
          ],
          score: 2,
          act: AddToAlways(mat: 1)
        )
      ),
      CharacterCard(
          character: Character(
              costs: [
                Cost(mats: [1,1])
              ],
              score: 1,
              act: AddToAlways(mat: 1)
          )
      ),
      CharacterCard(
          character: Character(
              costs: [
                Cost(mats: [1,1])
              ],
              score: 3,
              act: AddToAlways(mat: 1)
          )
      ),
      CharacterCard(
          character: Character(
              costs: [
                Cost(mats: [1,1])
              ],
              score: 4,
              act: AddToAlways(mat: 1)
          )
      ),
      CharacterCard(
          character: Character(
              costs: [
                Cost(mats: [1,1])
              ],
              score: 5,
              act: AddToAlways(mat: 1)
          )
      ),

    ];

    characterDeck.cards.shuffle(Random());
    characterDeck.resetField();

    // for(int i = 0; i < 2; i++){
    //   players.add(Player(game: this));
    // }
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


// class SelectMaterial extends Act{
//   SelectMaterial({
//     required this.index
//   });
//
//   int index;
//
//   @override
//   ActResult run(Game game, Player? player, Player? target) {
//     player!.SelectMatWithIndex(index);
//     return ActResult();
//   }
//
//   @override
//   String describe(Game game){
//     return "Select ${index}nd mat()";
//   }
// }

bool isMadeable(Player player, Character character) {
  for (Cost cost in character.costs) {
    List<int> playerMats = (player.hand.mats as List<ResourceCard>)
        .where((card) => (player.selectedMaterialCard.contains(card.mat)))
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


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// class ChangeCharacterGateToField extends Act{
//   @override
//   ActResult run(Game game, Player? player, Player? target){
//     player!.activeActs.add(ChangeCharacterGateToFieldSelectGate(indexOfGate: 0));
//     player!.activeActs.add(ChangeCharacterGateToFieldSelectGate(indexOfGate: 1));
//     player!.activeActs.add(ChangeCharacterGateToFieldSelectField(indexOfField: 0));
//     player!.activeActs.add(ChangeCharacterGateToFieldSelectField(indexOfField: 1));
//     player!.activeActs.add(ChangeCharacterGateToFieldFinal(indexOfGate: player.selectedGateIndex, indexOfField: player.selectedFieldIndex));
//     return ActResult();
//   }
// }

// class ChangeCharacterGateToFieldSelectGate extends Act{
//   ChangeCharacterGateToFieldSelectGate({
//     required this.indexOfGate
//   });
//   int indexOfGate;
//
//   ActResult run(Game game, Player? player, Player? target) {
//       player!.selectedGateIndex = indexOfGate;
//       return ActResult();
//   }
// }
//
// class ChangeCharacterGateToFieldSelectField extends Act{
//   ChangeCharacterGateToFieldSelectField({
//     required this.indexOfField
//   });
//   int indexOfField;
//
//   ActResult run(Game game, Player? player, Player? target) {
//     player!.selectedFieldIndex = indexOfField;
//     return ActResult();
//   }
// }


class ResourceCard extends Card {
  final int mat;
  final bool resetCharacterField;

  ResourceCard({
    required this.mat,
    this.resetCharacterField = false,
    bool selected = false,
  });

  @override
  ResourceCard clone() => ResourceCard(
    mat: mat,
    resetCharacterField: resetCharacterField,
  );


  // @override
  // ResourceCard setPosition(int newPos) => ResourceCard(
  //   pos: newPos,
  //   mat: mat,
  //   resetCharacterField: resetCharacterField,
  //   selected: selected,
  // );

  // // 팩토리 생성자 구현
  // factory ResourceCard.createNew() => ResourceCard(
  //   mat: Random().nextInt(5),
  //   resetCharacterField: false,
  // );
}

class CharacterCard extends Card {
  final Character character;

  CharacterCard({
    required this.character,
    bool selected = false,
  });

  @override
  CharacterCard clone() => CharacterCard(
    character: character,
  );

}

class Deck<T extends Card> {
  final int fieldCount;
  List<T> cards = [];
  List<T> used = [];
  List<T> field = [];

  Deck({required this.fieldCount});

  CardWithIndex? findCard(int id){
    for(int i = 0; i < cards.length; i++){
      if(cards[i].id == id){
        return CardWithIndex(card: cards[i], index: i);
      }
    }
    return null;
  }
  CardWithIndex? findCardInUsed(int id){
    for(int i = 0; i < used.length; i++){
      if(used[i].id == id){
        return CardWithIndex(card: used[i], index: i);
      }
    }
    return null;
  }
  CardWithIndex? findCardInField(int id){
    for(int i = 0; i < field.length; i++){
      if(field[i].id == id){
        return CardWithIndex(card: field[i], index: i);
      }
    }
    return null;
  }

  void restore() {
    if (cards.isNotEmpty) {
      print("Error: restore는 cards가 비었을 때 실행되어야함.");
      return;
    }
    used.shuffle(Random());
    cards = List<T>.from(used);
    used.clear();
  }

  T take() {
    if (cards.isEmpty) {
      restore();
    }
    return cards.removeAt(0);
  }

  T takeAtField(int index) {
    T takenCard = field[index].clone() as T;
    T newCard = take().setPosition(index) as T;
    field[index] = newCard;
    return takenCard;
  }

  void resetField() {
    used.addAll(field);
    field.clear();
    for (int i = 0; i < fieldCount; i++) {
      field.add(take().setPosition(i) as T);
    }
  }
}

class Player{
  String uid = "0001";

  Hand hand = Hand();//
  int crystal = 5;
  OpenField openField = OpenField();
  Gate gate = Gate();//
  Game game;//
  int score = 0;

  int remainTurn = 3;
  int maxTurn = 3;

  // List<Card> selectedCards = [];
  int selectedCrystals = 0;

  // List<Mat>

  // List<Widget> autoActs = []; //-----------------------------------------------------------
  List<Act> activeActs = [];
  List<Act> specialActs = [];

  // int selectedGateIndex = 0;
  // int selectedFieldIndex = 0;

  List<int> selectedMaterialCard = [];
  List<int> selectedGateCard = [];
  List<int> selectedFieldMaterialCard = [];
  List<int> selectedFieldCharacterCard = [];


  List<int> always = [];

  Player({
    required this.game,
    required this.uid
  });

  // void SelectMatWithIndex(int index){
  //   hand.mats[index].selected = !hand.mats[index].selected;
  // }


  ActResult executeAct(Game game, Player? target, Map<String, dynamic> jsonString) {
    // JSON 데이터 파싱
    var data = jsonString;
    String actName = data['act'];
    Map<String, dynamic> parameters = data['parameters'];

    // 액트 이름으로 매칭되는 액트를 찾음
    Act? actToExecute = activeActs.isNotEmpty ? activeActs.firstWhere((act) => act.runtimeType.toString() == actName) : null;

    if (actToExecute != null) {
      // 액트 실행
      return actToExecute.run(game, this, target, parameters);
    } else {
      print("No such act found: $actName");
      return ActResult(success: false);
    }
  }

  void addAct(Act act){
    specialActs.add(act);
  }

  void decreaseRemainTurn(){
    remainTurn -= 1;
  }


  List<Act> setAvailableActs(){
    if(remainTurn<1){
      return [];
    }
    List<Act> acts = [];
    acts.add(GetMatFromDeck());
    acts.add(GetMatFromField());
    if(gate.characters.length < 2){
      acts.add(GetCharacterFromDeck());
      acts.add(GetCharacterFromField());
    }
    acts.add(ResetMatField());

    for(int i = 0; i < gate.characters.length; i++){
      acts.add(Made());
    }

    acts += specialActs;

    activeActs = acts;
    return acts;
  }
}

class CardWithIndex{
  Card card;
  int index;
  CardWithIndex({
    required this.card,
    required this.index
  });
}

class Gate{
  List<CharacterCard> characters = [];

  void addCharacter(CharacterCard character){
    characters.add(character);
  }

  CardWithIndex? findCharacter(int id){
    for(int i = 0; i < characters.length; i++){
      if(characters[i].id == id){
        return CardWithIndex(card: characters[i], index: i);
      }
    }
    return null;
  }
}

class OpenField{
  List<CharacterCard> characters = [];
}

class Hand{
  List<ResourceCard> mats = [];

  void addMat(ResourceCard card){
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
