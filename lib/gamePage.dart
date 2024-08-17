// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/client.dart';
import 'package:molthar/gameController.dart';
import 'package:molthar/hostPage.dart';
// import 'sysClasses.dart';
import 'sysClasses.dart' as sys;
import 'costDef.dart';

class GamePage extends StatefulWidget {
  GamePage({
    super.key,

    // this.me = 0,
    // required this.controller
  });

  // int me = 0;
  // ClientController controller;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  void initState(){
    super.initState();

    // GameController.to.initGame();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx((){
        if(ClientController.to.started.value == false){
          return Text("no");
        }
        return SizedBox(
          width: double.infinity,
          // height: 650,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Gate(),
                      // TurnCounter()
                    ],
                  ),
                  Hand()
                ],
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("turn: ${ClientController.to.gameData.value.players[ClientController.to.index].remainTurn}"),
                    // ElevatedButton(onPressed: (){}, child: Text('end turn')),
                    MatDeck(),
                    CharDeck()
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
//
// class TurnCounter extends StatelessWidget {
//   const TurnCounter({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(GameController.to.game.value.players[].),
//     );
//   }
// }


class CharDeck extends StatelessWidget {
  const CharDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: List.generate(ClientController.to.gameData.value.characterField.length, (index){
        return FieldCharCard(index: index);
      }),
    ));
  }
}

class FieldCharCard extends StatelessWidget {
  FieldCharCard({
    super.key,
    required this.index
  });

  int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("tap");
        ClientController.to.sendToServer({
          'act': 'GetCharacterFromField',
          'parameters': {
            'index': index
          }
        }, 'data_response');
      },
      child: Container(
        height: 160,
        width: 70,
        decoration: BoxDecoration(
            color: Colors.redAccent
        ),
        child: Text(
          characterExplain(sys.Card.allCards[ClientController.to.gameData.value.characterField[index]]! as sys.CharacterCard)
        ),
      ),
    );
  }
}



class MatDeck extends StatelessWidget {
  const MatDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      print(ClientController.to.gameData.value.matField.length);
      return Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[GestureDetector(
              onTap: (){
                print("tap");
                ClientController.to.sendToServer({
                  'act': 'GetMatFromDeck',
                  'parameters': {}
                }, 'data_response');
              },
              child: Container(
                height: 160,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.greenAccent
                ),
                child: Text("deck"),
              ),
            )]
                + List.generate(ClientController.to.gameData.value.matField.length, (index){
              return FieldMatCard(index: index);
            }),
          ),
          GestureDetector(
            onTap:(){
              print("tap");
              ClientController.to.sendToServer({
                'act': 'ResetMatField',
                'parameters': {}
              }, 'data_response');
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.greenAccent
              ),
              child: Text("r"),
            ),
          )
        ],
      );
    });
  }
}

class FieldMatCard extends StatelessWidget {
  FieldMatCard({
    super.key,
    required this.index
  });

  int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("tap");
        ClientController.to.sendToServer({
          'act': 'GetMatFromField',
          'parameters': {
            'index': index
          }
        }, 'data_response');
        ClientController.to.selectedMaterials.clear();
        ClientController.to.selectedCrystals.value = 0;
      },
      child: Container(
        height: 160,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.greenAccent
        ),
        child: Text(ClientController.to.gameData.value.matField[index].toString()),
      ),
    );
  }
}

class HandMatCard extends StatelessWidget {
  HandMatCard({
    super.key,
    required this.index
  });

  int index;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: (){
        print("tap");
        if(ClientController.to.selectedMaterials.value.contains(index)){
          ClientController.to.selectedMaterials.value.remove(index);
        }
        else{
          ClientController.to.selectedMaterials.value.add(index);
        }
        ClientController.to.selectedMaterials.refresh();
        // ClientController.to.sendToServer({
        //   'act': 'GetMatFromField',
        //   'parameters': {
        //     'index': index
        //   }
        // }, 'data_response');
      },
      child: Container(
        height: 200,
        width: 100,
        decoration: BoxDecoration(
            color: ClientController.to.selectedMaterials.value.contains(index) ? Colors.greenAccent : Colors.orange
        ),
        child: Text(ClientController.to.secretGameData.value.hand[index].toString()),
      ),
    ));
  }
}



class Hand extends StatelessWidget {
  const Hand({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.grey
      ),
      child: Row(
        children: [for(int i = 0; i < ClientController.to.secretGameData.value.hand.length; i++) HandMatCard(index: i)],
      ),
    ));
  }
}


class Gate extends StatelessWidget {
  const Gate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
          color: Colors.grey
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(ClientController.to.gameData.value.players[ClientController.to.index].gate1 != null)
            GestureDetector(
              onTap: (){
                print("tap");
                ClientController.to.sendToServer({
                  'act': 'Made',
                  'parameters': {
                    'index': 0,
                    'crystal': ClientController.to.selectedCrystals.value,
                    'materials': ClientController.to.selectedMaterials.value
                  }
                }, 'data_response');
                ClientController.to.selectedMaterials.clear();
                ClientController.to.selectedCrystals.value = 0;
              },
              child: Container(
                height: 100,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.redAccent
                ),
                child: Text(
                    characterExplain(sys.Card.allCards[ClientController.to.gameData.value.players[ClientController.to.index].gate1]! as sys.CharacterCard)
                ),
              ),
            ),
          SizedBox(width: 20,),
          if(ClientController.to.gameData.value.players[ClientController.to.index].gate2 != null)
            GestureDetector(
              onTap: (){
                print("tap");
                ClientController.to.sendToServer({
                  'act': 'Made',
                  'parameters': {
                    'index': 1
                  }
                }, 'data_response');
                ClientController.to.selectedMaterials.clear();
                ClientController.to.selectedCrystals.value = 0;
              },

              child: Container(
                height: 100,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.redAccent
                ),
                child: Text(
                    characterExplain(sys.Card.allCards[ClientController.to.gameData.value.players[ClientController.to.index].gate2]! as sys.CharacterCard)
                ),
              ),
            ),
        ],
      ),
    ));
  }
}

String characterExplain(sys.CharacterCard character){
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