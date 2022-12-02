import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../game/components/GameIn_image.dart';
import '../game/components/GameIn_operate.dart';
import '../helpers/Constants.dart';

const double windowWidth = 1024;
const double windowHeight = 800;

class GameIn extends StatelessWidget {
  const GameIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment:Alignment.center,
                    height: 300,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 50, right: 50, top: 60, bottom: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD4A3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      '遊戲介紹\n' +
                          "玩家使用的左手來控制小方塊高低，碰到障礙物就結束遊戲!"
                              "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GameIn_operate(),
                ]),
          )),
    );
  }
}
