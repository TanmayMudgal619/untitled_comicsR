import 'package:flutter/material.dart';

import 'package:untitledcomics/globals/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitledcomics/set.dart';
import 'package:untitledcomics/ui/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/anime_spirited_away_no_face_nobody-512.png",
            ),
          ),
          Text(
            usr.username,
          ),
          ListTile(
            onTap: () {
              sharedPreferences.clear();
              set();
              get();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            title: const Text("LogOut!"),
          )
        ],
      ),
    );
  }
}
