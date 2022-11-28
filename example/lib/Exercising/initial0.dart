/*
import 'dart:async';
import 'package:body_detection_example/cc/poseList/Record.dart';
import 'package:body_detection_example/cc/sports%20menu/poseIntro.dart';
import 'package:body_detection_example/cc/sports%20menu/poselist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cc/helpers/Constants.dart';
import '../cc/poseList/poseRecord.dart';
import '../cc/sports menu/undoneList.dart';
import '../Exercising/detection//detection.dart';
import 'component/frame.dart';

*/
/*
void main() {
  runApp(const DetectionInitial());
}
*//*


class DetectionInitial extends StatefulWidget {
  late poseRecord record;

  DetectionInitial({Key? key}) : super(key: key);

  @override
  State<DetectionInitial> createState() {
    return _DetectionInitialState();
  }
}

class _DetectionInitialState extends State<DetectionInitial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading:IconButton(
            iconSize: 30,
            icon: Icon(Icons.cancel, size: 30.0, color: Colors.white),
            onPressed: () {
              debugPrint('Cancel');
              Navigator.push(

                  context, MaterialPageRoute(builder: (context) => PoseList()));
            },
          ) ,
          title: Text(
            UndoneList().getrecord().poseName,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.volume_up, size: 30.0, color: Colors.white),
              onPressed: () {
                debugPrint('volume_up');
              },
            ),
          ],
        ),
        body:Stack(
          children: const [
            ExerciseFrame(),
          ],
        )
      //ExerciseFrame(),
    );
  }
}

*/
