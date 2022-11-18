import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String value = "3";

class Setting2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Set to `true` to see the full possibilities of the iOS Developer Screen
    final bool runCupertinoApp = false;
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
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('每周目標天數 '),
                    dropdownButton(),
                  ]),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('運動提醒'),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('提醒時間'),
                    dropdownButton(),
                  ]),
            ),
          ],
        ),
        SettingsSection(
          title: Text('運動設定'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('休息秒數'),
                    dropdownButton(),
                  ]),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.format_paint),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('動作解說秒數 '),
                    dropdownButton(),
                  ]),
            ),
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
