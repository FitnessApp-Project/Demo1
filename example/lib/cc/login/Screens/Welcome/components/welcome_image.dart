import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:body_detection_example/cc/helpers/Constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "WELCOME",
          style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              /*child: SvgPicture.asset(
                "assets/images/未命名-1.png",
              ),*/
              child: Image.asset(
                  'assets/images/body.png'

              ),

            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}