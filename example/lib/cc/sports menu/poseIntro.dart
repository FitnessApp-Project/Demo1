import 'package:body_detection_example/cc/sports menu/undoneList.dart';
import 'package:body_detection_example/cc/sports%20menu/poselist.dart';
import 'package:flutter/material.dart';
import 'package:body_detection_example/cc/helpers/Constants.dart';
import '../../Exercising/initial.dart';
import '../poseList/Record.dart';
import '../poseList/poseRecord.dart';

class PoseIntro extends StatelessWidget {
  PoseIntro({Key? key}) : super(key: key);
  poseRecord record = UndoneList().getrecord();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.cancel, size: 30.0, color: Colors.white),
          onPressed: () {
            debugPrint('Cancel');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PoseList()));
          },
        ),
        title: Text(record.poseName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: _picture(context),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Color(0xFF000000),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                record.number + "\n\n" + record.introduction,
                style: TextStyle(fontSize: 20,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: [
              _buildbutton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _picture(BuildContext context) {
    return Container(
      height: 500,
      // color: Colors.brown,
      child: Image.network(
        record.photo,
      ),
      //child: Text(record.name),
    );
  }

  Widget _buildbutton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetectionInitial(),
            ));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 70,
          width: 150,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 7,
              ),
            ],
          ),
          child: const Text(
            '開始',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
