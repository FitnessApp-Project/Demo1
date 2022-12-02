import 'RecordList.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class RecordService {

  Future<String> _loadRecordsAsset() async {
    // return await rootBundle.loadString('assets/data/records.json');
    return await rootBundle.loadString('assets/data/trainMenuForLeg.json');
  }

  Future<RecordList> loadRecords() async {
    String jsonString = await _loadRecordsAsset();
    final jsonResponse = json.decode(jsonString);
    RecordList records = new RecordList.fromJson(jsonResponse);
    return records;
  }

}