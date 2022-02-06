import 'package:flutter/material.dart';

import 'package:untitledcomics/globals/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitledcomics/globals/tags.dart';
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
            child: Image.asset("assets/images/logo.png"),
          ),
          Text(
            usr.username,
          ),
          ListTile(
            title: const Text("Data Saver"),
            onTap: () {
              setState(() {
                dataSaver = !dataSaver;
                sharedPreferences.setBool("dataSaver", dataSaver);
              });
            },
            trailing: Switch(
                value: dataSaver,
                onChanged: (value) {
                  setState(() {
                    dataSaver = value;
                    sharedPreferences.setBool("dataSaver", dataSaver);
                  });
                }),
          ),
          ListTile(
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: CupertinoPicker(
                          itemExtent: 40.0,
                          magnification: 1.2,
                          useMagnifier: true,
                          looping: true,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              lang = languages[value];
                              sharedPreferences.setString("lang", lang);
                            });
                          },
                          children: languages
                              .map((e) => Text(
                                    e,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  });
            },
            title: const Text("Language"),
            trailing: Text(lang.toUpperCase()),
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
