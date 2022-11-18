import 'poseRecordList.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class poseRecordService {

  Future<String> _loadRecordsAsset() async {
    return await rootBundle.loadString('assets/data/posedata.json');
  }

  Future<poseRecordList> loadRecords() async {
    String jsonString = await _loadRecordsAsset();
    final jsonResponse = json.decode(jsonString);
    poseRecordList records = new poseRecordList.fromJson(jsonResponse);
    return records;
  }

}