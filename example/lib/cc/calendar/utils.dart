// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'dart:collection';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

DateTime kToday = DateTime.now();

/*List  Day = [
  {
    "Date": DateTime.now(),
    "event" : Event('1 | 分鐘數: 1 | 次數:1'),
  },
  {
    "Date":  DateTime(2022, 11, 9, 23, 55, 0),
    "event" :Event('3 | 分鐘數: 3 | 次數:3'),
  }
];*/

var Day = [
  DateTime.now(),
  DateTime(2022, 11, 9, 23, 55, 0),
  DateTime(2022, 11, 20, 23, 55, 0),
];

List<Event> test = [
  Event('1 | 分鐘數: 1 | 次數:1'),
  Event('2 | 分鐘數: 2 | 次數:2'),
];

List<Event> test2 = [
  Event('1 | 分鐘數: 1 | 次數:1'),
  Event('2 | 分鐘數: 2 | 次數:2'),
];

var name = [
  0,
  2,
  3,
  1,
  2,
  3,
  2,
  2,
];

var minute = [
  0,
  2,
  3,
  2,
  1,
  2,
  3,
  2,
];
var count = [
  0,
  2,
  3,
  2,
  1,
  2,
  3,
  2,
];

var Eventnum = [
  1,
  1,
  2,
  1,
];

var i = 0;

final _kEventSource = {
  for (var itme in Day)
    //  for (var i =0;i<name.length;i++)
    DateTime.utc(itme.year, itme.month, itme.day):
        //Event('$itmes | 分鐘數: ${itmes} | 次數:${itmes}')
        //test

        List.generate(
            Eventnum.elementAt(i++),

            (index) => Event(
                '${name[index+i]} | 分鐘數:${minute[index+i]} | 次數:${count[index+i]} '))
  //${index + 1}
};


int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/*
/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
*/

/*
final kFirstDay = DateTime(kToday.year, kToday.month , kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);*/
