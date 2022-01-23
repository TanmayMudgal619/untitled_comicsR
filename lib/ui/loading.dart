import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'home.dart';

class Loading extends StatefulWidget {
  //To Load New Comics Updates for The home Page
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Future<List<List<Manga>>> data;
  @override
  void initState() {
    super.initState();
    data = homeload();
    data.then((value) {
      latestManga = value[0];
      updatedManga = value[1];
      slideshowManga = value[2];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}
