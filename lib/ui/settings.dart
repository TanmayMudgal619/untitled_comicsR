import 'package:flutter/material.dart';

import 'package:untitledcomics/globals/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitledcomics/globals/tags.dart';
import 'package:untitledcomics/set.dart';
import 'package:untitledcomics/ui/helper.dart';
import 'package:untitledcomics/ui/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset("assets/images/logo.png"),
          ),
          Text(
            (login) ? (usr.username) : ("Incognito"),
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
              searchedManga.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            title: Text(login ? ("Log Out") : ("Log In")),
          ),
          ListTile(
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    // deviceMode = MediaQuery.of(context).orientation;
                    return Padding(
                      padding:
                          EdgeInsets.all(((size.width > 500) ? (10.0) : (0.0))),
                      child: Align(
                        alignment: ((size.width > 500)
                            ? (Alignment.center)
                            : (Alignment.bottomCenter)),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: (size.width > 500) ? (500) : (size.width),
                            height: (size.width > 500)
                                ? (500)
                                : (size.height * 0.68),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ExpandWidget(
                                    heading: "Creator",
                                    child: const ListTile(
                                      title: Text("tanmaymudgal619"),
                                    ),
                                    expanded: true,
                                  ),
                                  ExpandWidget(
                                    heading: "Contributor",
                                    child: const ListTile(
                                      title: Text("Riktam-Santra"),
                                    ),
                                    expanded: true,
                                  ),
                                  ExpandWidget(
                                    heading: "Data Provided By",
                                    child: const ListTile(
                                      title: Text("Mangadex"),
                                    ),
                                    expanded: true,
                                  ),
                                  ExpandWidget(
                                    heading: "Thanks",
                                    child: const ListTile(
                                      title: Text(
                                        "We are thankful to mangadex to let us use their data without charges and helped Us whenever needed (through Discord) only because of their help we are able to complete this Project.\nWe also Respect every Author, Scanlator and Everyone who directly and indirectly helped us in the completion of the App.",
                                      ),
                                    ),
                                    expanded: true,
                                  ),
                                  ExpandWidget(
                                    heading: "Message For User",
                                    child: const ListTile(
                                      title: Text(
                                          "Use our App for reading your favourite comics With time we will definately add more and more options for your better experience might even remove some.\nAnd to do so we need your feedback. So, if you found any error or have any suggestions then you can contact us on tanmaymudgal619@gmail.com."),
                                    ),
                                    expanded: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
            title: const Text("Credits"),
          )
        ],
      ),
    );
  }
}
