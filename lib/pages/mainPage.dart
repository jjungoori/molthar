import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molthar/client.dart';
import 'package:molthar/hostPage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async{
            await GameServerController.to.startServer();
            await ClientController.to.joinServer();
            Get.toNamed('/lobby');
          }, child: Text("호스트 되기")),
          ElevatedButton(onPressed: () async{
            await ClientController.to.joinServer();
            Get.toNamed('/lobby');
          }, child: Text("참여하기"))
        ],
      ),
    );
  }
}
