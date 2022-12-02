import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // Init
  String key = "show";
  String value = "Nothing";
  TextEditingController controller = TextEditingController();

  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      value = (sp.getString(key) ?? "Nothing");
    });
  }

  _updateData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString(key, controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Your message: ${value}"),

            // Input box
            TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                labelText: "You can enter any string",
                hintText: "Your message",
              ),
            )
          ],
        ),
      ),

      // Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            value = controller.text;
            _updateData();
          });
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}