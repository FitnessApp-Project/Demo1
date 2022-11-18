import 'package:body_detection_example/cc/poseList/Record.dart';
import 'package:flutter/material.dart';

class PoseImage extends StatelessWidget {
  const PoseImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: Colors.yellow,
        image: DecorationImage(
          image: new ExactAssetImage('assets/images/IMG_20200704_134015.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
