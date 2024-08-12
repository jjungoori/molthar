import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/gameController.dart';
// import 'sysClasses.dart';
import 'sysClasses.dart' as sys;
import 'costDef.dart';

class GamePage extends StatefulWidget {
  GamePage({
    super.key,

    this.me = 0
  });

  int me = 0;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  void initState(){
    super.initState();

    GameController.to.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Gate(),
                  TurnCounter()
                ],
              ),
              Hand()
            ],
          ),

          Column(
            children: [
              MatDeck(),
              CharDeck()
            ],
          )
        ],
      ),
    );
  }
}

class TurnCounter extends StatelessWidget {
  const TurnCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(GameController.to.game.value.players[].),
    );
  }
}


class CharDeck extends StatelessWidget {
  const CharDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GameController.to.game.value.characterDeck.field.length, (index){
        return CharCard(card: GameController.to.game.value.characterDeck.field[index]);
      }),
    );
  }
}

class CharCard extends StatelessWidget {
  CharCard({
    super.key,
    required this.card
  });

  sys.Card card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.redAccent
      ),
      child: Text(
        characterExplain(card!)
      ),
    );
  }
}



class MatDeck extends StatelessWidget {
  const MatDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GameController.to.game.value.matDeck.field.length, (index){
        return MatCard(card: GameController.to.game.value.matDeck.field[index]);
      }),
    );
  }
}

class MatCard extends StatelessWidget {
  MatCard({
    super.key,
    required this.card
  });

  sys.Card card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.greenAccent
      ),
      child: Text(card.mat.toString()),
    );
  }
}



class Hand extends StatelessWidget {
  const Hand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey
      ),
      child: Row(
        children: [],
      ),
    );
  }
}


class Gate extends StatelessWidget {
  const Gate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),
          SizedBox(width: 20,),
          Container(
            height: 100,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}

String characterExplain(sys.Card character){
  String result = "";
  
  for(int i = 0; i < character.character!.costs[0].mats.length; i++){
    result += character.character!.costs[0].mats[i].toString() + ", ";
  }
  for(int i = 0; i < character.character!.costs[0].crystal; i++){
    result += "@";
  }
  result += "\n";
  result += "score: ${character.character!.score} ";
  for(int i = 0; i < character.character!.crystal; i++){
    result += "@";
  }
  result += "\n${character.character!.act.toString()}";

  return result;
}