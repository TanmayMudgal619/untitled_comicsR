import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/search.dart';
import 'settings.dart';
import 'helper.dart';
import 'library.dart';
import 'search.dart';

class Home extends StatefulWidget {
  Home();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 2;
  late CupertinoNavigationBar searchInput;
  List<Widget> homepage = [
    Container(
      child: const Text(
        "Explore",
        style: TextStyle(color: Colors.white),
      ),
    ),
    SizedBox(
      child: SearchManga(),
    ),
    SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SlideShow(mangaList: slideshowManga),
            const Padding(padding: EdgeInsets.all(20)),
            MangaRow(title: "Latest Added Mangas", mangaList: latestManga),
            const Padding(padding: EdgeInsets.all(20)),
            MangaRow(title: "Recently Updated Mangas", mangaList: updatedManga),
            const Padding(
                padding: EdgeInsets.all(kBottomNavigationBarHeight / 2)),
          ],
        ),
      ),
    ),
    Library(),
    const Settings()
  ];

  @override
  void initState() {
    searchInput = CupertinoNavigationBar(
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          CupertinoIcons.search,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(
          CupertinoIcons.slider_horizontal_3,
        ),
      ),
      middle: TextField(
        decoration: const InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
        ),
        controller: searchedManga,
        onChanged: (value) {
          if (searchedManga.text.isEmpty) {
            if (isSearch) {
              setState(() {
                mangaSearching.ignore();
                isSearch = false;
              });
            }
          }
        },
        onSubmitted: (value) {
          if (searchedManga.text.isNotEmpty) {
            setState(() {
              isSearch = true;
              mangaSearching = searchmanga(searchedManga.text, '50', '0');
            });
          } else {
            setState(() {
              mangaSearching.ignore();
              isSearch = false;
            });
          }
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homepage[1] = SizedBox(
      child: SearchManga(),
    );
    deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: (deviceMode == Orientation.portrait)
          ? ((currentIndex == 1)
              ? (searchInput)
              : (CupertinoNavigationBar(
                  middle: Image.asset("assets/images/logo.png"),
                )))
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
                                if (currentIndex != 1) {
                                  setState(() {
                                    currentIndex = 1;
                                  });
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.search,
                              ),
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
            child: Column(
              children: [
                (currentIndex == 1 && deviceMode == Orientation.landscape)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: (searchInput),
                        ),
                      )
                    : (SizedBox()),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                        (deviceMode == Orientation.landscape) ? 10 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(
                          (deviceMode == Orientation.landscape) ? 10 : 0)),
                      child: Container(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? (Colors.black26)
                            : (Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: homepage.elementAt(currentIndex),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
