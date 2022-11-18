import 'dart:async';
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
import '../../cc/sports menu/undoneList.dart';
import 'pose_mask_painter.dart';

class Detection extends StatefulWidget {
  const Detection({
    Key? key,
  }) : super(key: key);

  @override
  State<Detection> createState() => _DetectionState();

  void stopstream() {
    _DetectionState()._stopCameraStream();
  }
}

class _DetectionState extends State<Detection> {
  bool _isDetectingPose = false;

  //bool _isDetectingBodyMask = false;
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;
  CameraDescription? cameraDescription;
  List<CameraDescription> cameras = [];
  late CameraController _camera; //final

  @override
  void initState() {
    _startCameraStream();
    _toggleDetectPose();
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
        },
      );
    }
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();
    _camera.dispose();
    print('stop');
    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
    });
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

  @override
  Widget build(BuildContext context) {
    double _defaultRatio = 100.0;
    return Stack(
      children: [
        CustomPaint(
          child: _cameraImage,
          foregroundPainter: PoseMaskPainter(
            pose: _detectedPose,
            mask: _maskImage,
            imageSize: _imageSize,
          ),
        ),
        //CameraPreview(_camera),
      ],
    );
  }
}
