
import 'package:flutter/material.dart';

import '../poseList/poseRecord.dart';

class PoseImage extends StatelessWidget {

  const PoseImage({
    required this.pose
  }) ;
  final poseRecord pose;
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
          image: new ExactAssetImage(pose.photo),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
