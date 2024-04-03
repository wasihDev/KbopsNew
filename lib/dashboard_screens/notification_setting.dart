import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 37, 65),
        centerTitle: true,
        title: Text("Notification Setting"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Turn on Notifications [On/Off]"),
            trailing: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.red,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.grey,
            ),
          ),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }
}
