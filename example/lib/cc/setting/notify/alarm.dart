import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:body_detection_example/cc/setting/notify/screens/second_screen.dart';
import 'package:body_detection_example/cc/setting/notify/services/local_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../Setting2.dart';

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
SharedPreferences? prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs!.containsKey(countKey)) {
    await prefs!.setInt(countKey, 0);
  }

  runApp(const AlarmManagerExampleApp());
}

/// Example app for Espresso plugin.
class AlarmManagerExampleApp extends StatelessWidget {
  const AlarmManagerExampleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: _AlarmHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class _AlarmHomePage extends StatefulWidget {
  const _AlarmHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<_AlarmHomePage> {
  int _counter = 0;
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();

    AndroidAlarmManager.initialize();
    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await _incrementCounter());
    super.initState();
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => SecondScreen(payload: payload))));
    }
  }

  Future<void> _incrementCounter() async {
    developer.log('Increment counter!');
    // Ensure we've loaded the updated count from the background isolate.
    await prefs?.reload();

    setState(() {
      _counter++;
    });
  }

  DateTime date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      Setting2().getNotifyTime()!.hour,
      Setting2().getNotifyTime()!.minute,
      DateTime.now().second);

  // The background
  static SendPort? uiSendPort;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback() async {
    print("alarm fired");
    //developer.log('Alarm fired!');
    print(DateTime.now());
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

  }

  Future<void> notify() async {
    await AndroidAlarmManager.oneShotAt(
      //DateTime.parse("${DateTime.now().year}${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute+1}"),
      //DateTime.parse("2022-12-02 20:29:04Z"),
      //DateTime.utc(2022, 12, 2,DateTime.now().hour,DateTime.now().minute, DateTime.now().second, ),
      //DateTime.utc(2022, 12, 2,20,34,04),
      date,
      Random().nextInt(pow(2, 31) as int),
      callback,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> show() async {
    print("++++++++++++++++++++");
    await service.showNotification(
        id: 0, title: 'Notification Title', body: 'Some body');
    print("44444444444");
    print(date);
    print(DateTime.now());
    print("---------------------");
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alarm fired $_counter times',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total alarms fired: ',
                  style: textStyle,
                ),
                Text(
                  prefs?.getInt(countKey).toString() ?? '',
                  key: const ValueKey('BackgroundCountText'),
                  style: textStyle,
                ),
              ],
            ),
            ElevatedButton(
              key: const ValueKey('RegisterOneShotAlarm'),
              onPressed: () async {
await AndroidAlarmManager.oneShot(
                  Duration(seconds: 5),
                  Random().nextInt(pow(2, 31) as int),
                  callback,
                  exact: true,
                  wakeup: true,
                );

DateTime date = DateTime(2022, 12, 2, DateTime.now().hour,
                    DateTime.now().minute, DateTime.now().second );
                print(date);
                print(DateTime.now());
                print(Setting2().getNotifyTime());

                print(date);
                await AndroidAlarmManager.periodic(
                  Duration(seconds: 5),
                  Random().nextInt(pow(2, 31) as int),
                  callback,
                  startAt: date,
                  exact: true,
                  wakeup: true,
                  rescheduleOnReboot: true,

                );
                Future.delayed(Duration(seconds: 10)).then((value) {
                  show();
                 // print("延时3秒执行 then ");
                });
              },
              child: const Text(
                'Schedule OneShot Alarm',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
