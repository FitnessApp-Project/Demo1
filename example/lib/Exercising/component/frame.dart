import 'dart:async';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection_example/cc/sports%20menu/undoneList.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cc/helpers/Constants.dart';
import '../../cc/sports menu/poseIntro.dart';
import '../../Exercising/detection/detection.dart';
import '../restTime.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/png_image.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Exercising/detection/pose_mask_painter.dart';

class ExerciseFrame extends StatefulWidget {

  const ExerciseFrame({Key? key }) : super(key: key) ;
  @override
  State<ExerciseFrame> createState() => _FrameState();
}

class _FrameState extends State<ExerciseFrame> {
  int count = 0;
  bool a = false;
  late Timer timer;

  Future<int> _getTime() async {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (count > 0) {
        setState(() {
          count -= 1;
        });

      } else {
        UndoneList().removefirst();
        timer.cancel();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RestTime()));

      }
    });
    return count;
  }

  Future<void> _showPoseIntro(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('posename'),
          content: Container(
            height: 400,
            width: 300,
            // height: 70 * StorageUtil.getDouble("textScaleFactor"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Text('總金額：' + '9999', style: TextStyle(color: Colors.black)),
                */
                Image.asset('assets/images/IMG_20200704_134015.jpg'),
                Text('動作解說：' + 'XXXXX',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                Text('次數/組數' + 'XXXXXX',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text('取消', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _getTime();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setFrameColor() {
    if (a) {
      poseFrameColor = Colors.green;
    } else {
      poseFrameColor = Colors.red;
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Positioned(bottom: 0 ,left: 0,child: Detection()),
            Positioned(
              top: -280,
              child: Container(
                width: 500,
                height: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 203, 42),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            //--邊框
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: poseFrameColor,
                      width: 25,
                      style: BorderStyle.solid),
                ),
              ),
            ),
            const Positioned(
              top: 50,
              left: 60,
              child: Text(
                "次數",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
            Positioned(
              top: 80,
              child: Text(
                count.toString(),
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            ),
            Positioned(
              right: 60,
              top: 50,
              child: Text(
                "10下/組",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 40,
              child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.question_mark, size: 30.0, color: Colors.grey),
                onPressed: () {
                  debugPrint('Cancel');
                  _showPoseIntro(context);
                  timer.cancel();

                  //----邊框顏色測試
                  if (a) {
                    a = false;
                    _setFrameColor();
                  } else {
                    a = true;
                    _setFrameColor();
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

