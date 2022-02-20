import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/loading.dart';
import 'package:untitledcomics/ui/login.dart';
// import 'package:desktop_window/desktop_window.dart';
import 'package:untitledcomics/ui/theme.dart';
import 'set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DesktopWindow.setMinWindowSize(const Size(1200, 800));
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
