import 'dart:async';
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

const double stageSize = 500;
const double wallHeight = 300;
const double size = 30;

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
  double wallx = 0;
  Direction direction = Direction.none;
  double Y = 400;
  GameState gameState = GameState.Running;
  late Timer timer;
  Detection detection = new Detection();
  int score = 0;
  double wallWidth = 50;


  @override
  void initState(){
    gameState = GameState.Running;

  }

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    timer = Timer.periodic(duration, (timer) {
      double newY2 = getY;
      print("${getY}......................");
      double newY = newY2;
      Direction newdir = direction;
      GameState newstate = gameState;

      /*switch (direction) {
        case Direction.up:
          newY--;
          if (newY < 150) {
            newdir = Direction.down;
          }
          break;
        case Direction.down:
          newY++;
          if (newY > stageSize) {
            newdir = Direction.none;
          }
          break;
      }*/
      if (wallx < size && Y >= stageSize - wallHeight ) {
        print("game state dead");
        setState(() {
          newstate = GameState.Dead;
        });

      }
      setState(() {
        if (wallx <=  wallWidth) {
          score++;
        }
        wallx = (wallx - 1 + stageSize) % stageSize;
        Y = newY;
        direction = newdir;
        gameState = newstate;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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

              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(builder: (BuildContext context) {
                return tabBar();
              }));
            },
          ),
        ),
        body: gameState == GameState.Running
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    //direction = Direction.up;
                    timer.cancel();
                    detection.stopstream();
                  });
                },
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 10, left: 40, right: 40, bottom: 0),
                        padding: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 189, 122, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text("分數 $score"),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: stageSize,
                        decoration: BoxDecoration(
                          color: Colors.red,
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
                                    center: Offset(wallx, MediaQuery.of(context).size.width),
                                    width: wallWidth,
                                    height: wallHeight),
                                child: Container(
                                  color: Colors.green,
                                  child: Text('${wallx.toString()}/ ${stageSize.toString()}/ ${wallHeight.toString()}'),
                                ))
                          ],
                        ),
                        //  ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        gameState = GameState.Running;
                      });
                    },
                    //child: Text(Y.toString()),
                    child: Text("Game over"),
                  ),
                ),
              ));
  }
}
