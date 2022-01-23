import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png", //App Logo
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: TextFormField(
                          controller: usrnm,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black26,
                                width: 3,
                              ),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: TextFormField(
                          controller: pswd,
                          obscureText: !show,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black26,
                                width: 3,
                              ),
                            ),
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
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListTile(
                          tileColor: Colors.white24,
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Loading(),
                                ),
                              );
                            }
                          },
                          title: const Text(
                            "LogIn",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ListTile(
                          tileColor: Colors.white24,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          leading: const Icon(Icons.person_off_rounded),
                          onTap: () {
                            incognitoMode = true;
                            sharedPreferences.setBool("incognitoMode", true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loading()));
                          },
                          title: const Text(
                            "Incognito",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
