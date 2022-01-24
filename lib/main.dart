// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/loading.dart';
import 'package:untitledcomics/ui/login.dart';
import 'package:untitledcomics/ui/theme.dart';
import 'set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  bool check = sharedPreferences.getBool("set") ?? false;
  if (!check) {
    set();
  }
  get();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      title: "Untitled Comics",
      home: (incognitoMode == true)
          ? (Loading())
          : ((login) ? (Loading()) : (Login())),
    );
  }
}
