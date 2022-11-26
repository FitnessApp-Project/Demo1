import 'dart:async';
import 'package:body_detection_example/cc/game/GameIn.dart';
import 'package:flutter/material.dart';
import '../tabBar.dart';

class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  State<Play> createState() => _PlayState();
}

const double stageSize = 400;
const double wallHeight = 60;
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
  double wallx = stageSize;
  Direction direction = Direction.none;
  double Y = 400;
  GameState gameState = GameState.Running;
  late Timer timer;

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    Timer.periodic(duration, (timer) {
      double newY = Y;
      Direction newdir = direction;
      GameState newstate = gameState;
      switch (direction) {
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
      }
      if (wallx < size && Y > stageSize - wallHeight) {
        setState(() {
          newstate = GameState.Dead;
        });
      }

      setState(() {
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
        appBar: AppBar(
          leading: IconButton(
            iconSize: 30,
            icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => GameIn()));
            },
          ),
        ),
        body: gameState == GameState.Running
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    direction = Direction.up;
                  });
                },
                child: Container(
                  width: stageSize,
                  height: stageSize,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black26),
                  ),
                  child: Stack(
                    children: [
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
                              center: Offset(wallx, stageSize),
                              width: 30,
                              height: 100),
                          child: Container(
                            color: Colors.green,
                          ))
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
                        timer.cancel();
                      });
                    },
                    child: Text("Game over"),
                  ),
                ),
              ));
  }
}
