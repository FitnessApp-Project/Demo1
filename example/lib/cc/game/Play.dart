import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:body_detection_example/cc/game/components/CameraArea.dart';

import 'components/game_detection.dart';
import 'package:body_detection_example/cc/game/GameIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tabBar.dart';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../helpers/Constants.dart';
import 'GameOver.dart';

class Play extends StatelessWidget {
  Play({Key? key}) : super(key: key);
  late Timer timer;
  Detection detection = new Detection();
/*

  @override
  State<Play> createState() => _PlayState();
}
*/

/*
class _PlayState extends State<Play> {


  @override
  void initState() {

  }
*/

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
      body: CameraArea(),
    );
  }
}
