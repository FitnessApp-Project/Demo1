import 'dart:io';

import 'package:body_detection_example/Exercising/restTime.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'notify/screens/second_screen.dart';
import 'notify/services/local_notification_service.dart';

String value = "3";

class Setting2 extends StatefulWidget {
  const Setting2({Key? key}) : super(key: key);

  @override
  State<Setting2> createState() => _Setting2State();

  int getRestTime() {
    return _Setting2State().getRestTime();
  }

  TimeOfDay? getNotifyTime() {
    return _Setting2State().getNotifyTime();
  }
}

class _Setting2State extends State<Setting2> {
  final TextEditingController myController = new TextEditingController();
  static int restTime = 5; //運動間休息預設
  //static DateTime notifytime = DateTime.utc(DateTime.now().hour,DateTime.now().minute, DateTime.now().second); //預設通知時間

  late final LocalNotificationService service;
  TimeOfDay t = TimeOfDay.fromDateTime(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 0, 0));
  bool isSwitched = false;

  //TimeOfDay t= TimeOfDay.fromDateTime(DateTime.now());
  static String? time; //預設通知時間

  int getRestTime() {
    return restTime;
  }

  TimeOfDay? getNotifyTime() {
    return t;
  }

  void showNotify() async {
    await service.showNotification(id: 0, title: '運動提醒', body: time.toString());
  }

  @override
  initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    time = t.toString().substring(10, 15);
    super.initState();
  }

  Future<TimeOfDay?> selectTime(context) async {
    t = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now())))!;

    /*将选择日期显示出来*/
    setState(() {
      //String? apm = t?.period.toString() == 'DayPeriod.am' ? '上午' : '下午';
      time = t.toString().substring(10, 15);
    });
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

  @override
  Widget build(BuildContext context) {
    //final bool runCupertinoApp = false;
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('帳戶設定'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('個人資料'),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('帳密設定'),
            ),
          ],
        ),
        SettingsSection(
          title: Text('通知設定'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              initialValue: isSwitched,
              //switchValue: isSwitched,
              onToggle: (value) async {
                setState(() {
                  isSwitched = value;
                });
                if(value==true){
                  await service.showNotification(
                      id: 0, title: '運動提醒', body: time.toString());
                }

              },
              leading: Icon(Icons.share_arrival_time_outlined),
              title: Text('運動提醒'),

              /*trailing: ElevatedButton(
                onPressed: () async {
                  await service.showNotification(
                      id: 0, title: '運動提醒', body:time.toString() );
                },
                child: const Text('Local Notification'),
              ),*/
            ),
            SettingsTile.navigation(
              // leading: Icon(Icons.access_time_filled),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('提醒時間: $time'),
                    TextButton(
                      onPressed: () {
                        selectTime(context);
                      },
                      child: Text("選擇時間"),
                    )
                    //dropdownButton(),
                  ]),
            ),
          ],
        ),
        SettingsSection(
          title: Text('運動設定'),
          tiles: <SettingsTile>[
            /*動作介紹時間，目前是手動控制。待考慮
           SettingsTile.navigation(
                leading: Icon(Icons.format_paint),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('休息秒數 '),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 3,
                        decoration: InputDecoration(
                          hintText: restTime.toString(),
                        ),
                        onChanged: (String value) {
                          //print("${value}+++++++++++++");
                          //print("${myController.text}");
                          setState(() {
                            restTime = int.parse(value);
                          });
                          //RestTime().setTime(restTime);
                        },
                      ),
                    ),
                  ],
                )),*/
            SettingsTile.navigation(
                leading: Icon(Icons.timer),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('動作解說秒數 '),
                    SizedBox(
                      width: 55,
                      child: TextField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 3,
                        decoration: InputDecoration(
                          hintText: restTime.toString(),
                          suffixText: "秒",
                        ),
                        onChanged: (String value) {
                          setState(() {
                            restTime = int.parse(value);
                          });
                          //RestTime().setTime(restTime);
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }
}

DropdownButton dropdownButton() {
  return DropdownButton(
    dropdownColor: Colors.black,
    items: <DropdownMenuItem<String>>[
      DropdownMenuItem(
        child: Text(
          "1111",
          style: TextStyle(color: value == "1" ? Colors.red : Colors.green),
        ),
        value: "1",
      ),
      DropdownMenuItem(
        child: Text(
          "2222",
          style: TextStyle(color: value == "2" ? Colors.red : Colors.green),
        ),
        value: "2",
      ),
      DropdownMenuItem(
        child: Text(
          "3333",
          style: TextStyle(color: value == "3" ? Colors.red : Colors.green),
        ),
        value: "3",
      ),
      DropdownMenuItem(
        child: Text(
          "4444",
          style: TextStyle(color: value == "4" ? Colors.red : Colors.green),
        ),
        value: "4",
      ),
    ],
    hint: new Text("提示資訊"),
// 當沒有初始值時顯示

    onChanged: (selectValue) {
//選中後的回撥
// setState(() {
//   value = selectValue;
// });
    },
    value: value,
    // 設定初始值，要與列表中的value是相同的
    elevation: 10,
    //設定陰影
    style: new TextStyle(
        //設定文字框裡面文字的樣式
        color: Colors.blue,
        fontSize: 15),
    iconSize: 30,
    //設定三角標icon的大小
    underline: Container(
      margin: EdgeInsets.only(left: 50),
      height: 1,
      color: Colors.blue,
    ), // 下劃線
  );
}
