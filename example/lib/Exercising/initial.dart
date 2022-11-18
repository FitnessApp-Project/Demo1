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
  bool _isDetectingPose = false;
  bool _isDetectingBodyMask = false;
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;
  CameraDescription? cameraDescription;
  List<CameraDescription> cameras = [];
  late CameraController _camera; //final
  int count = 0;
  bool a = false;
  late Timer timer;
  Detection detection = new Detection();

  Future<int> _getTime() async {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (count > 0) {
        setState(() {
          count -= 1;
        });
      } else {
        UndoneList().removefirst();
        timer.cancel();
        _stopCameraStream();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RestTime()));
      }
    });
    return count;
  }

  @override
  void initState() {
    super.initState();
    count = 5;
    _startCameraStream();
    _toggleDetectPose();
    _getTime();
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

  Future<void> _startCameraStream() async {
    WidgetsFlutterBinding.ensureInitialized();
    final request = await Permission.camera.request();
    cameras = await availableCameras();
    _camera = CameraController(
      cameras[0],
      ResolutionPreset.low,
    );

    if (request.isGranted) {
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          if (!_isDetectingPose) return;
          _handlePose(pose);
          setState(() {
            CameraPreview(_camera);
          });
        },
        onMaskAvailable: (mask) {
          if (!_isDetectingBodyMask) return;
          _handleBodyMask(mask);
          setState(() {
            CameraPreview(_camera);
          });
        },
      );
    }
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();
    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
    });
  }

  void _handleCameraImage(ImageResult result) {
    if (!mounted) return;

    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.contain,
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

  void _handleBodyMask(BodyMask? mask) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    if (mask == null) {
      setState(() {
        _maskImage = null;
      });
      return;
    }

    final bytes = mask.buffer
        .expand(
          (it) => [0, 0, 0, (it * 255).toInt()],
        )
        .toList();
    ui.decodeImageFromPixels(Uint8List.fromList(bytes), mask.width, mask.height,
        ui.PixelFormat.rgba8888, (image) {
      setState(() {
        _maskImage = image;
      });
    });
  }

  Future<void> _toggleDetectPose() async {
    if (_isDetectingPose) {
      await BodyDetection.disablePoseDetection();
    } else {
      await BodyDetection.enablePoseDetection();
    }

    setState(() {
      _isDetectingPose = !_isDetectingPose;
      _detectedPose = null;
    });
  }

//--------------------------------------------
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
