import 'dart:async';
import 'dart:io';
import 'dart:math';
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
  double wallWidth = 80;
  int newScore = 0;
  double move = 1;
  double safeArea = (Random().nextInt(8) + 1) / 10;

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
      /*if (wallx < size && Y >= stageHeight - wallHeight) {
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

        if (wallx < size * 2.5 &&
          (Y - size <= safeArea * stageHeight - 65 ||
              Y >= safeArea * stageHeight + 35)) {
        setState(() {
          if (newScore > score) {
            score = newScore;
          }
          timer.cancel();
          detection.stopstream();
          //print("$score +++++++++++++++");

          Navigator.of(context).pop();
        });
      }
      setState(() {
        if (wallx.truncate() <= 0) {
          newScore++;
          safeArea = (Random().nextInt(8) + 1) / 10;
        }
        wallx = (wallx - move) % stageWidth;
        wall2x = (wall2x - move) % stageWidth;
        Y = newY;
        gameState = newstate;
      });
    });
    super.didChangeDependencies();
  }

/*  Future<void> _showPoseIntro(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            "GAME OVER",
            style: TextStyle(fontSize: 20),
          ),
          content: Container(
            height: 400,
            width: 300,
            // height: 70 * StorageUtil.getDouble("textScaleFactor"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/IMG_20200704_134015.jpg'),
              *//*  Text('動作解說：' + "\n" + UndoneList().getrecord().introduction,
                    style: TextStyle(color: Colors.black, fontSize: 20)),*//*

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text('確定', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

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
              height: 100,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 189, 122, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Text(
                "分數 $newScore $safeArea",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: stageHeight,
              decoration: BoxDecoration(
                //color: Colors.red,
                border: Border(
                    top: BorderSide(
                        color: kPrimaryDarkColor,
                        width: 12,
                        style: BorderStyle.solid),
                    bottom: BorderSide(
                        color: kPrimaryDarkColor,
                        width: 8,
                        style: BorderStyle.solid)),
              ),
              /* border: Border.all(
                      color: kPrimaryDarkColor,
                      width: 8,
                      style: BorderStyle.solid)),*/
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: detection,
                  ),
                  /*Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center:
                              Offset(wallx, MediaQuery.of(context).size.width),
                          width: wallWidth,
                          height: MediaQuery.of(context).size.height),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      )),*/
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center:
                          Offset(wallx, safeArea * stageHeight - 140 - wallHeight),
                          width: wallWidth,
                          height: MediaQuery.of(context).size.height),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      )),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center:
                          Offset(wallx,safeArea * stageHeight + 140  + wallHeight),
                          width: wallWidth,
                          height: MediaQuery.of(context).size.height),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      )),

                  //safe area
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: Offset(wall2x, safeArea * stageHeight),
                          width: wallWidth,
                          height: 100),
                      child: Container(
                        //color: Color.fromRGBO(51,225, 0, 0.2),
                        color: Colors.transparent,
                        child: Text(
                            '${(safeArea * stageHeight - 50).toString()}\n '),
                      )),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: Offset(size, Y), width: size, height: size),
                      child: Container(
                        color: Colors.orange,
                        child: Text('${Y}'),
                      )),
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
