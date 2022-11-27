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
                  Expanded(
                    flex: 1,
                   child: GameIn_image(),
                  ),
                  GameIn_operate(),
                ]),
          )),
    );
  }
}
