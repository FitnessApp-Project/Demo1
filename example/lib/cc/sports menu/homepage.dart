import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:body_detection_example/cc/sports menu/poselist.dart';

const double BoxHeight = 200.0;
const double gap = 5.0;

var icon_list = <IconData>[
  Icons.format_list_bulleted,
  Icons.edit,
  Icons.thumb_up,
  Icons.star_border,
];

var boxlabel = <String>[
  '腿部訓練動作列表',
  '自訂訓練表',
  '簡單訓練表',
  '困難訓練課表',
];



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(context) {
    //final controller = Provider.of<InfiniteProcessIsolateController>(context);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => MyItem(index),
            ),
          ),
        ],
      ),
    );
  }
}

class MyItem extends StatelessWidget {
  final int index;

  const MyItem(this.index);

  @override
  Widget build(BuildContext context) {
    final color = Colors.orange[200 + 100 * (index + 1)];
    return InkWell(
      child: Container(
        //alignment: Alignment.center,
        height: 120,
        margin: EdgeInsets.only(left: 50, top: 20, right: 50, bottom: 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: 20,
              child: Icon(
                icon_list[index],
                size: 100,
                color: Color.fromRGBO(255, 255, 255, 0.4),
              ),
            ),
            //Text('Scrollable 2 : Index $index'),
            Center(
              child: Stack(
                children: [
                  Positioned(
                    child: Text(
                      boxlabel[index],
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print("Click event on Container" + index.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PoseList()));
      },
    );
  }
}
