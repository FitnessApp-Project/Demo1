import 'dart:async';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection_example/Exercising/restTime.dart';
import 'package:body_detection_example/cc/sports%20menu/undoneList.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../cc/helpers/Constants.dart';

import '../../Exercising/detection/detection.dart';
import 'dart:typed_data';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/png_image.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Exercising/detection/pose_mask_painter.dart';
import '../cc/sports menu/poselist.dart';
import 'component/frame.dart';

class DetectionInitial extends StatefulWidget {
  const DetectionInitial({Key? key}) : super(key: key);

  @override
  State<DetectionInitial> createState() => _DetectionInitialState();
}

class _DetectionInitialState extends State<DetectionInitial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.cancel, size: 30.0, color: Colors.white),
          onPressed: () {
            debugPrint('Cancel');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PoseList()));
            ExerciseFrame().stopTime();
          },
        ),
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
      body: const Center(
        child: ExerciseFrame(),
      ),
    );
  }
}
