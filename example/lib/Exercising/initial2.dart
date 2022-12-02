import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:body_detection_example/cc/tabBar.dart';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:body_detection_example/poseRecognition/counterPaint.dart';
import 'package:body_detection_example/poseRecognition/outSidePaint.dart';
import 'package:body_detection_example/poseRecognition/HalfCircle.dart';
import 'package:body_detection_example/poseRecognition/pose_mask_painter.dart';
import 'package:body_detection_example/cc/helpers/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:body_detection_example/poseRecognition/provider.dart'
    as globals;
import 'package:body_detection_example/Exercising/restTime.dart';

class DetectionInitial extends StatefulWidget {
  const DetectionInitial(
      {Key? key,
      required this.SportName,
      required this.number,
      required this.Content,
      required this.image});

  final String SportName;
  final String number;
  final String Content;
  final String image;

  @override
  State<DetectionInitial> createState() => _DetectionInitialState();
}

class _DetectionInitialState extends State<DetectionInitial> {
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.infinite;
  CameraDescription? cameraDescription;
  List<CameraDescription> cameras = [];
  late final CameraController _camera;
  late bool a = false;

  @override
  void initState() {
    _startCameraStream();
    // globals.Provider.initVariables();
    // NOTE: Calling this function here would crash the app.
    // print("sportName" + sportName);
  }

  @override
  deactivate() {
    super.deactivate();
    BodyDetection.stopCameraStream();

    globals.Provider.initVariables();
    // sportName = globals.Provider.record.poseName;
  }

  @override
  dispose() {
    globals.Provider.initVariables();
    BodyDetection.stopCameraStream();
    globals.Provider.initVariables();
  }

  Future<void> _startCameraStream() async {
    await BodyDetection.enablePoseDetection();
    WidgetsFlutterBinding.ensureInitialized();
    final request = await Permission.camera.request();
    print(request);
    cameras = await availableCameras();
    _camera = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    if (request.isGranted) {
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          // if (!_isDetectingPose) return;
          _handlePose(pose);
          setState(() {
            CameraPreview(_camera);
          });
        },
      );
    }
  }

  Future<void> jumpToHomePage() async {
    deactivate();
    Future.delayed(Duration.zero, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => tabBar()));
    });
  }

  Future<void> jumpToRestTime() async {
    deactivate();
    Future.delayed(Duration.zero, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RestTime()));
    });
  }

  void _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );

    setState(() {
      _cameraImage = image;
      _imageSize = result.size;
      print("Size " + _imageSize.toString());
    });
  }

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    setState(() {
      _detectedPose = pose;
    });
  }

  _setFrameColor() {
    if (a == true) {
      poseForBorder = Colors.green;
    } else {
      poseForBorder = Colors.red;
    }
  }

  Future<void> _showPoseIntro(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            // "asdasdsa",
            widget.SportName,
            style: TextStyle(fontSize: 20),
          ),
          content: Container(
            height: 600,
            width: 300,
            // height: 70 * StorageUtil.getDouble("textScaleFactor"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(widget.image),
                Text('動作解說：' + "\n" + widget.Content,
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                /*Text('次數/組數' + UndoneList().getrecord().number,
                    style: TextStyle(color: Colors.black, fontSize: 15)),*/
              ],
            ),
          ),
        );
      },
    );
  }

  // && (globals.Provider.record == globals.Provider.undoneList.getLastrecord())
  @override
  Widget build(BuildContext context) {
    if (globals.Provider.squatState == "Done" ||
        globals.Provider.legpulloverState == "Done" ||
        globals.Provider.kneelinglegraiseState == "Done" ||
        globals.Provider.pyramidStretchState == "Done" ||
        globals.Provider.sidelegraiseState == "Done" ||
        globals.Provider.lungeState == "Done" ||
        globals.Provider.statedForwardBendStretchState == "Done") {
      jumpToRestTime(); // 跳到休息時間
    }
    ;
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40), // here the desired height
          child: AppBar(
            backgroundColor: poseForBorder,
            leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.cancel, size: 30.0, color: Colors.white),
              onPressed: () {
                debugPrint('Cancel');
                Future.delayed(Duration.zero, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => tabBar()));
                  deactivate();
                });
              },
            ),
            title: Text(
              widget.SportName,
              style: TextStyle(fontSize: 25),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.question_mark,
                    size: 30.0, color: Colors.white),
                onPressed: () {
                  print("問號被按下");

                  _showPoseIntro(context);
                  // // timer.cancel();
                  //----邊框顏色測試
                  if (a == true) {
                    a = false;
                    _setFrameColor();
                  } else {
                    a = true;
                    _setFrameColor();
                  }
                },
              ),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.volume_up,
                    size: 30.0, color: Colors.white),
                onPressed: () {
                  debugPrint('volume_up');
                },
              ),
            ],
            elevation: 0,
          ),
        ),
        body: Container(
          foregroundDecoration: BoxDecoration(
            border: new Border(
              bottom: BorderSide(width: 50, color: poseForBorder),
              left: BorderSide(width: 20, color: poseForBorder),
              right: BorderSide(width: 20, color: poseForBorder),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                color: kPrimaryColor,
                child: CustomPaint(
                  size: Size.fromHeight(120),
                  foregroundPainter: counterPaint(widget.number),
                ),
              ),
              Expanded(
                child: RepaintBoundary(
                  child: CustomPaint(
                    child: _cameraImage,
                    foregroundPainter: PoseMaskPainter(
                      pose: _detectedPose,
                      mask: _maskImage,
                      imageSize: _imageSize,
                      sportName: widget.SportName,
                    ),
                  ),
                ),
              ),
            ],
          ), // CustomPaint
        ),
      ),
    );
  }
}
