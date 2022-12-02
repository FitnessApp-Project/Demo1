import 'dart:async';

import 'dart:math';

import 'game_detection.dart';
import '../../helpers/Constants.dart';
import '../GameOver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CameraArea extends StatefulWidget {
  CameraArea({Key? key}) : super(key: key);

  @override
  State<CameraArea> createState() => _CameraAreaState();
}

const double stageHeight = 500;
const double wallHeight = 300;
const double size = 30;
double stageWidth = 0;

class _CameraAreaState extends State<CameraArea> {
  late double wallx;
  late double wall2x;
  double Y = 400;

  late Timer timer;
  Detection detection = new Detection();
  double wallWidth = 80;
  int newScore = 0;
  double move = 1;
  double safeArea = (Random().nextInt(8) + 1) / 10;

  @override
  void initState() {
    wallx = stageWidth;
    wall2x = stageWidth;
    newScore = 0;
  }

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    timer = Timer.periodic(duration, (timer) {
      double newY = getY;


      if (wallx < size * 2.5 &&
          (Y - size <= safeArea * stageHeight - 65 ||
              Y >= safeArea * stageHeight + 35)) {
        setState(() {
          if (newScore > score) {
            score = newScore;
          }
          timer.cancel();
          detection.stopstream();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GameOver(currentScore: newScore,)));
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context)
              ..pop()
              ..pop();
          });
          //Navigator.of(context).pop();
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
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    stageWidth = MediaQuery.of(context).size.width;
    return Center(
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
                "分數 $newScore ",
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
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: detection,
                  ),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: Offset(
                              wallx, safeArea * stageHeight - 140 - wallHeight),
                          width: wallWidth,
                          height: MediaQuery.of(context).size.height),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            '${wallx.toString()}/ ${stageWidth.toString()}/ ${wallHeight.toString()}'),
                      )),
                  Positioned.fromRect(
                      rect: Rect.fromCenter(
                          center: Offset(
                              wallx, safeArea * stageHeight + 140 + wallHeight),
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

    );
  }
}
