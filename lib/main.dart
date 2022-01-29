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
  // await sharedPreferences.clear();
  // return;
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
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Untitled Comics",
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      home: (incognitoMode == true)
          ? (const Loading())
          : ((login) ? (const Loading()) : (const Login())),
    );
  }
}
