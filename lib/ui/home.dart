import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/api/classes.dart';
import 'homepage.dart';

class Home extends StatefulWidget {
  Home();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (deviceMode == Orientation.portrait)
          ? (CupertinoNavigationBar(
              automaticallyImplyLeading: false,
              middle: (currentIndex == 1)
                  ? (TextFormField())
                  : ((Theme.of(context).brightness == Brightness.light)
                      ? (ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            -1, 0, 0, 0, 255, //
                            0, -1, 0, 0, 255, //
                            0, 0, -1, 0, 255, //
                            0, 0, 0, 1, 0, //
                          ]),
                          child: Image.asset("assets/images/logo.png"),
                        ))
                      : (Image.asset("assets/images/logo.png"))),
            ))
          : (null),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          (deviceMode == Orientation.landscape)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 75,
                      child: (SingleChildScrollView(
                        primary: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  currentIndex = 2;
                                });
                              },
                              child: const Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage("assets/images/logo.png"),
                                  radius: 33,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            IconButton(
                              onPressed: () {
                                if (currentIndex != 0) {
                                  setState(() {
                                    currentIndex = 0;
                                  });
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.compass,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (currentIndex != 3) {
                                  setState(() {
                                    currentIndex = 3;
                                  });
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.bookmark,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (currentIndex != 4) {
                                  setState(() {
                                    currentIndex = 4;
                                  });
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.settings,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                )
              : (const SizedBox(
                  width: 0,
                  height: 0,
                )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                  (deviceMode == Orientation.landscape) ? 10 : 0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(
                    (deviceMode == Orientation.landscape) ? 10 : 0)),
                child: Container(
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? (Colors.black12)
                      : (Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: potraitMode.elementAt(currentIndex),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: (deviceMode == Orientation.portrait)
          ? SizedBox(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: (BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    currentIndex: currentIndex,
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: Icon(
                          CupertinoIcons.compass,
                        ),
                        label: "Explore",
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: Icon(
                          CupertinoIcons.search,
                        ),
                        label: "Search",
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: Icon(
                          CupertinoIcons.home,
                        ),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: Icon(
                          CupertinoIcons.bookmark,
                        ),
                        label: "Library",
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: Icon(
                          CupertinoIcons.settings,
                        ),
                        label: "Settings",
                      ),
                    ],
                  )),
                ),
              ),
            )
          : (null),
    );
  }
}
