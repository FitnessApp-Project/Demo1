import 'dart:io';
import 'dart:typed_data';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/png_image.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pose_mask_painter.dart';
import 'counterPaint.dart';
import 'outSidePaint.dart';
import 'HalfCircle.dart';


import 'provider.dart' as globals;


class Detection extends StatefulWidget {
  const Detection({Key? key}) : super(key: key);

  @override
  State<Detection> createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.infinite;
  CameraDescription? cameraDescription;
  List<CameraDescription> cameras = [];
  late final CameraController _camera;


  @override
  void initState() {
    super.initState();
    // NOTE: Calling this function here would crash the app.
    _startCameraStream();
    print("hello World");
  }

  Future<void> _startCameraStream() async {
    await BodyDetection.enablePoseDetection();
    print("h2222222222566414");
    WidgetsFlutterBinding.ensureInitialized();
    final request = await Permission.camera.request();
    print(request);
    cameras = await availableCameras();
    _camera = CameraController(
      cameras[0],
      ResolutionPreset.low,
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

  void _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    // To avoid a memory leak issue.
    // https://github.com/flutter/flutter/issues/60160
    // PaintingBinding.instance?.imageCache?.clear();
    //PaintingBinding.instance?.imageCache?.clearLiveImages();

    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.fitWidth,
    );

    setState(() {
      _cameraImage = image;
      _imageSize = result.size;
    });
  }

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    setState(() {
      _detectedPose = pose;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     decoration : new BoxDecoration(
    //         border: new Border.all(color: Color(0xFFFFFF00), width: 50),
    //         color: Colors.white,
    //     ),
    //
    // );
    return MaterialApp(
      home:   Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("運動名稱"),
          centerTitle: true,
          backgroundColor: Colors.yellow,
        ),
      body:
        RepaintBoundary(
            child:
              CustomPaint(
                  // size: const Size(360.0 ,566.0),
                  // foregroundPainter:outSidePaint(),
                  child:
                  Column(
                    children: <Widget>[
                      Stack(
                          children: <Widget>[
                              CustomPaint(
                                size:Size.fromHeight(86),
                                painter: HalfCircle(),
                              ),
                              CustomPaint(
                                size:Size.fromHeight(86),
                                foregroundPainter:counterPaint(),
                              ),
                          ]
                      ),
                      RepaintBoundary(
                        child:CustomPaint(
                          // size: const Size(double.infinity, double.infinity),
                          // size:Size.fromWidth(360),
                          child: _cameraImage,
                          foregroundPainter: PoseMaskPainter(
                            pose: _detectedPose,
                            mask: _maskImage,
                            imageSize: _imageSize,
                          ),
                        ),
                      ),
                    ],
                  )
              )
          ),



      ),
    );
  }
}
