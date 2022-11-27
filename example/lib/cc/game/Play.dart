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

enum Direction {
  up,
  down,
  none,
}

enum GameState {
  Running,
  Dead,
}

class _PlayState extends State<Play> {
  double wallx = stageWidth;
  Direction direction = Direction.none;
  double Y = 400;
  GameState gameState = GameState.Running;
  late Timer timer;
  Detection detection = new Detection();
  double wallWidth = 50;
  int newScore=0;

  @override
  void initState() {
    gameState = GameState.Running;
    wallx = stageWidth;
    newScore = 0;
  }

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    timer = Timer.periodic(duration, (timer) {
      double newY = getY;
      Direction newdir = direction;
      GameState newstate = gameState;

      if (wallx < size && Y >= stageHeight - wallHeight) {
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
      }
      setState(() {
        if (wallx <= 0) {
          newScore++;
        }
        wallx = (wallx - 1 + stageWidth) % stageWidth;
        Y = newY;
        direction = newdir;
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
              /*         Navigator.push(
                  context, MaterialPageRoute(builder: (context) => tabBar()));*/
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GestureDetector(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 0),
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 189, 122, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text("分數 $newScore"),
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
                              center: Offset(
                                  wallx, MediaQuery.of(context).size.width),
                              width: wallWidth,
                              height: wallHeight),
                          child: Container(
                            color: Colors.green,
                            child: Text(
                                '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                          ))
                    ],
                  ),
                  //  ),
                ),
              ],
            ),
          ),
        ));
  }
}
