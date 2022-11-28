import 'package:body_detection_example/cc/Sports%20menu/homepage.dart';
import 'package:body_detection_example/cc/sports%20menu/poseImage.dart';
import 'package:body_detection_example/cc/sports%20menu/poseIntro.dart';
import 'package:body_detection_example/cc/sports%20menu/undoneList.dart';
import 'package:flutter/material.dart';

import 'package:body_detection_example/cc/helpers/Constants.dart';
import '../../Exercising/detection/detection.dart';
import 'package:body_detection_example/cc/poseList/poseRecord.dart';
import 'package:body_detection_example/cc/poseList/poseRecordList.dart';
import 'package:body_detection_example/cc/poseList/poseRecordService.dart';
import '../tabBar.dart';

class PoseList extends StatefulWidget {
  @override
  _PoseListState createState() {
    return _PoseListState();
  }
}

class _PoseListState extends State<PoseList> {
  poseRecordList _records = new poseRecordList(records: []);
  poseRecordList _filteredRecords = new poseRecordList(records: []);
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _records.records = [];
    _filteredRecords.records = [];
    _getRecords();
  }

  void _getRecords() async {
    poseRecordList records = (await poseRecordService().loadRecords()) as poseRecordList;
    setState(() {
      for (poseRecord record in records.records) {
        this._records.records.add(record);
        this._filteredRecords.records.add(record);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appDarkGreyColor,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => tabBar()));
          },
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Positioned(
            child: _banner(context),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: 120),
              color: appGreyColor,
              alignment: Alignment.center,
              child: _buildList(context),
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

  Widget _banner(BuildContext context) {
    return Container(
      height: 120,
      child: Stack(
        children: [
          Positioned(
            bottom: 15,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '簡單訓練課表',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: appGreyColor,
                  ),
                ),
                Text(
                  '共計7組動作',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: appGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    if (!(_searchText.isEmpty)) {
      _filteredRecords.records = [];
      for (int i = 0; i < _records.records.length; i++) {
        if (_records.records[i].poseName
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            _records.records[i].number
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          _filteredRecords.records.add(_records.records[i]);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: this
          ._filteredRecords
          .records
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, poseRecord record) {
    return Card(
      key: ValueKey(record.poseName),
      elevation: 8.0,
      shadowColor: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Color.fromRGBO(252, 202, 156, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  child: PoseImage(),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          record.poseName,
                          style: const TextStyle(fontSize: 22,color: kPrimaryDarkColor),
                        ),
                        Text(
                          record.number,
                          style: const TextStyle(fontSize: 18,color: kPrimaryDarkColor),
                        ),
                      ],
                    ),
                  )),
            ]),
      ),
    );
  }

  Widget _buildbutton(BuildContext context) {
    return GestureDetector(
    onTap: () {
        //print('12315');
        UndoneList().setrecordList(_records);
         Navigator.push(
                  context,
                  MaterialPageRoute(
                      //builder: (context) => Detection()));
                      builder: (context) => PoseIntro()));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 70,
          width: 200,
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
            '開始訓練',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
