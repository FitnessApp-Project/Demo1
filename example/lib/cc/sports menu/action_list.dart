import 'package:flutter/material.dart';
import 'package:body_detection_example/cc/helpers/Constants.dart';

import 'package:body_detection_example/cc/poseList/poseRecord.dart';
import 'package:body_detection_example/cc/poseList/poseRecordList.dart';
import 'package:body_detection_example/cc/poseList/poseRecordService.dart';
import '../tabBar.dart';
//import '../../poseRecognition/detection.dart';
import 'package:body_detection_example/poseRecognition/detection.dart';

class ActionList extends StatefulWidget {
  @override
  State<ActionList> createState() {
    return _ActionListState();
  }
}

class _ActionListState extends State<ActionList> {
  //final TextEditingController _filter = new TextEditingController();
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
    poseRecordList records =
        (await poseRecordService().loadRecords()) as poseRecordList;
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
        title: Text(
          "運動列表",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),

      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Container(
              // margin: EdgeInsets.only(top: 150),
              color: appGreyColor,
              alignment: Alignment.center,
              child: _buildList(context), // 建立card
            ),
          ),
        ],
      ), // resizeToAvoidBottomInset: false,
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
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(record.photo),
              )),
          title: Text(
            record.poseName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              new Flexible(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: record.poseName,
                        style: TextStyle(color: Colors.white),
                      ),
                      maxLines: 3,
                      softWrap: true,
                    )
                  ]))
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Detection()));
          },
        ),
      ),
    );
  }
}
