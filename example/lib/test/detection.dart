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
import 'pose_mask_painter.dart';

class Detection extends StatefulWidget {
  const Detection({Key? key}) : super(key: key);

  @override
  State<Detection> createState() => _MyAppState();
}

class _MyAppState extends State<Detection> {
  bool _isDetectingPose = false;
  bool _isDetectingBodyMask = false;
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;
  CameraDescription? cameraDescription;
  List<CameraDescription> cameras = [];
  late CameraController _camera; //final

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

  Future<void> _toggleDetectBodyMask() async {
    if (_isDetectingBodyMask) {
      await BodyDetection.disableBodyMaskDetection();
    } else {
      await BodyDetection.enableBodyMaskDetection();
    }

    setState(() {
      _isDetectingBodyMask = !_isDetectingBodyMask;
      _maskImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRect(
                  child: CustomPaint(
                    child: _cameraImage,
                    foregroundPainter: PoseMaskPainter(
                      pose: _detectedPose,
                      mask: _maskImage,
                      imageSize: _imageSize,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _startCameraStream,
                  child: const Text('Camera open'),
                ),
                OutlinedButton(
                  onPressed: _stopCameraStream,
                  child: const Text('Camera stop'),
                ),
                OutlinedButton(
                  onPressed: _toggleDetectPose,
                  child: _isDetectingPose
                      ? const Text('Turn off pose detection')
                      : const Text('Turn on pose detection'),
                ),
                OutlinedButton(
                  onPressed: _toggleDetectBodyMask,
                  child: _isDetectingBodyMask
                      ? const Text('Turn off body mask detection')
                      : const Text('Turn on body mask detection'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
