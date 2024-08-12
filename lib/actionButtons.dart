import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/gameController.dart';
import 'package:molthar/sysClasses.dart';
import 'package:molthar/sysClasses.dart' as sys;
import 'costDef.dart';

class TurnButtons extends StatelessWidget {
  const TurnButtons({super.key});

  @override
  Widget build(BuildContext context) {
    printCost(n12345);
    return Obx(() => Column(
      children: [
        ElevatedButton(
            onPressed: (){
              GameController.to.initGame();
              GameController.to.setActs();
            },
            child: Text("act s")
        ),
        ElevatedButton(
            onPressed: (){
              GameController.to.resChange();
            },
            child: Text("change res")
        ),
        ElevatedButton(
            onPressed: (){
              GameController.to.game.value.players[0].remainTurn += 1;
              GameController.to.resChange();
            },
            child: Text("get turn")
        ),
        if(GameController.to.game.value.players.length>0)
          Text(GameController.to.game.value.players[0].remainTurn.toString()),
        SizedBox(height: 10,),
        ListView.builder(
          shrinkWrap: true,
          itemCount: GameController.to.acts.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
                onPressed: (){
                  GameController.to.acts[index].run(GameController.to.game.value, GameController.to.game.value.players[0], GameController.to.game.value.players[1]);
                  GameController.to.resChange();
                  },
                child: Text(GameController.to.acts[index].describe(GameController.to.game.value))
            );
          },),
        Fields(),
        Row(
          children: List.generate(GameController.to.game.value.players.length, (index) => PlayerShower(player: GameController.to.game.value.players[index])),
        )
      ],
    ));
  }
}

class Fields extends StatelessWidget {
  const Fields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          children: List.generate(GameController.to.game.value.matDeck.field.length, (index) =>
            ElevatedButton(onPressed: (){}, child: Text(GameController.to.game.value.matDeck.field[index].mat!.toString()))
          ),
        ),
        Row(
          children: List.generate(GameController.to.game.value.characterDeck.field.length, (index) =>
              CharacterButton(card: GameController.to.game.value.characterDeck.field[index])
          ),
        ),
      ],
    ),);
  }
}

class PlayerShower extends StatelessWidget {
  PlayerShower({
    super.key,
    required this.player
  });

  Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      // width: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange
      ),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children:List.generate(player.hand.mats.length, (index) =>
                    ElevatedButton(
                        onPressed: (){
                          player.SelectMatWithIndex(index);
                          GameController.to.resChange();
                        },
                        child: Text(player.hand.mats[index].mat!.toString()),
                      style: ElevatedButton.styleFrom(backgroundColor: player.hand.mats[index].selected ? Colors.green : Colors.blue),
                    )
                ),
              ),
              GateShower(gate: player.gate),
            ],
          ),
          Column(
            children: [
              Text("crystal: ${player.crystal}"),
              OpenFieldShower(openField: player.openField)
            ],
          ),
          Column(
            children: [
          ElevatedButton(onPressed: (){}, child: Text("UseCrystal")),
          ElevatedButton(onPressed: (){}, child: Text("UnUseCrystal")),
            ],
          )
        ],
      ),
    );
  }
}

class GateShower extends StatelessWidget {
  GateShower({
    super.key,
    required this.gate
  });

  Gate gate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      // width: 50,
      padding: EdgeInsets.all(20),
      color: Colors.red,
      child: Row(
        children:List.generate(gate.characters.length, (index) =>
          CharacterButton(card: gate.characters[index])
        ),
      )
    );
  }
}



class OpenFieldShower extends StatelessWidget {
  OpenFieldShower({
    super.key,
    required this.openField
  });

  OpenField openField;

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 50,
        // width: 50,
        padding: EdgeInsets.all(20),
        color: Colors.greenAccent,
        child: Column(
          children:List.generate(openField.characters.length, (index) =>
              CharacterButton(card: openField.characters[index],)
          ),
        )
    );
  }
}




class CharacterButton extends StatelessWidget {
  CharacterButton({
    super.key,
    required sys.Card this.card
  });

  sys.Card card;

  @override
  Widget build(BuildContext context) {
    Character character = card.character!;
    return ElevatedButton(
        onPressed: (){
          Game game = GameController.to.game.value;
          Made(index: card.pos).run(game, game.players[0], game.players[1]);
        },
        child: Column(
          children: [
            // Text(character.cost.describe()),
            Text("score: " + character.score.toString() + "and " + character.crystal.toString() + " crystal")
          ],
        )
    );
  }
}



class TurnButton extends StatelessWidget {
  const TurnButton({
    super.key,
    required this.turn
  });

  final Turn turn;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){

    }, child: Text(turn.name));
  }
}

