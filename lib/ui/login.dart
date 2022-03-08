import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/set.dart';
import 'loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usrnm = TextEditingController();
  TextEditingController pswd = TextEditingController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text(
          "Login",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(),
                SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: TextFormField(
                          controller: usrnm,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: pswd,
                        obscureText: !show,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          filled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                show = !show;
                              });
                            },
                            child: Icon(
                              (show)
                                  ? (Icons.remove_red_eye)
                                  : (Icons.remove_red_eye_outlined),
                              size: 20,
                            ),
                          ),
                          labelText: 'Password',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          leading: const Icon(Icons.login),
                          onTap: () async {
                            if (usrnm.text.isNotEmpty && pswd.text.isNotEmpty) {
                              var a;
                              try {
                                a = await loginUser(usrnm.text, pswd.text);
                              } catch (e) {
                                if (e.toString() ==
                                    "Exception: Error code : 400") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Invalid Username/Password!",
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
                                return;
                              }
                              sharedPreferences.setBool("incognitoMode", false);
                              sharedPreferences.setString(
                                  "session", a["session"]);
                              sharedPreferences.setString(
                                  "refresh", a["refresh"]);
                              sharedPreferences.setString(
                                  "username", usrnm.text);
                              sharedPreferences.setBool("login", true);
                              incognitoMode = false;
                              login = true;
                              get();
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const Loading(),
                                ),
                              );
                            }
                          },
                          title: const Text(
                            "LogIn",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          leading: const Icon(Icons.person_off_rounded),
                          onTap: () {
                            sharedPreferences.clear();
                            set();
                            get();
                            sharedPreferences.setBool("incognitoMode", true);
                            incognitoMode = true;
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const Loading(),
                              ),
                            );
                          },
                          title: const Text(
                            "Incognito",
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
