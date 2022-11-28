import 'dart:async';
import 'dart:io';
import '../game/game_detection.dart';
import 'package:body_detection_example/cc/game/GameIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tabBar.dart';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../helpers/Constants.dart';

class Play extends StatefulWidget {
  Play({Key? key}) : super(key: key);

  @override
  State<Play> createState() => _PlayState();
}

const double stageHeight = 500;
const double wallHeight = 300;
const double size = 30;
double stageWidth = 0;

enum GameState {
  Running,
  Dead,
}

class _PlayState extends State<Play> {
  late double wallx;
  late double wall2x;
  double Y = 400;
  GameState gameState = GameState.Running;
  late Timer timer;
  Detection detection = new Detection();
  double wallWidth = 50;
  int newScore = 0;
  double move = 2;

  @override
  void initState() {
    gameState = GameState.Running;
    wallx = stageWidth;
    wall2x = stageWidth;
    newScore = 0;
  }

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    timer = Timer.periodic(duration, (timer) {
      double newY = getY;
      GameState newstate = gameState;

      //死亡判斷
      /* if (wallx < size && Y >= stageHeight - wallHeight) {
        setState(() {
          if(newScore>score){
            score=newScore;
          }
          timer.cancel();
          detection.stopstream();
          print("$score +++++++++++++++");
          Navigator.of(context).pop();
          print("$score-----------");
        });
      }*/

      setState(() {
        if (wallx.truncate() <= 0) {
          newScore++;
        }
        wallx = (wallx - move) % stageWidth;
        wall2x = (wall2x - move) % stageWidth;
        Y = newY;
        gameState = newstate;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    stageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 234, 203, 1.0),
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
          onPressed: () {
            timer.cancel();
            detection.stopstream();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 189, 122, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("分數 $newScore $move"),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: stageHeight,
              decoration: BoxDecoration(
                //color: Colors.red,
                border: Border(
                    bottom: BorderSide(
                        color: kPrimaryDarkColor,
                        width: 8,
                        style: BorderStyle.solid)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: detection,
                  ),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: Offset(0, Y - size / 2),
                          width: size,
                          height: size),
                      child: Container(
                        color: Colors.orange,
                      )),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center:
                              Offset(wallx, MediaQuery.of(context).size.width),
                          width: wallWidth,
                          height: wallHeight),
                      child: Container(
                        color: Colors.green,
                        child: Text(
                            '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      )),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center:
                          Offset(wall2x, 0),
                          width: wallWidth,
                          height: wallHeight),
                      child: Container(
                        color: Colors.green,
                        child: Text(
                            '${wall2x.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      ))
                ],
              ),
              //  ),
            ),
          ],
        ),
      ),
    );
  }
}
