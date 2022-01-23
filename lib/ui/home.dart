import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/globals/globals.dart';
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
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          child: Image.asset(
            "assets/images/bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: (deviceMode == Orientation.portrait)
              ? (CupertinoNavigationBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  middle: Image.asset("assets/images/logo.png"),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: (Drawer(
                            backgroundColor: Colors.black26,
                            elevation: 0.0,
                            child: SingleChildScrollView(
                              primary: false,
                              child: Column(
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
                                    child: const DrawerHeader(
                                      margin: EdgeInsets.zero,
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(
                                              "assets/images/logo.png"),
                                          radius: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      if (currentIndex != 0) {
                                        setState(() {
                                          currentIndex = 0;
                                        });
                                      }
                                    },
                                    leading: const Icon(
                                      CupertinoIcons.compass,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      "Explore",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      if (currentIndex != 3) {
                                        setState(() {
                                          currentIndex = 3;
                                        });
                                      }
                                    },
                                    leading: const Icon(
                                      CupertinoIcons.bookmark,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      "Library",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      if (currentIndex != 4) {
                                        setState(() {
                                          currentIndex = 4;
                                        });
                                      }
                                    },
                                    leading: const Icon(
                                      CupertinoIcons.settings,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      "Setting",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
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
                      color: Colors.black26,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: potraitMode.elementAt(currentIndex),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: (deviceMode == Orientation.portrait)
              ? Container(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: (BottomNavigationBar(
                        backgroundColor: Colors.transparent,
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
                            label: "Library",
                          ),
                          BottomNavigationBarItem(
                            backgroundColor: Colors.transparent,
                            icon: Icon(
                              CupertinoIcons.bookmark,
                            ),
                            label: "Search",
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
        ),
      ],
    );
  }
}
