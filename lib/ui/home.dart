import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/globals/tags.dart';
import 'package:untitledcomics/ui/randommanga.dart';
import 'package:untitledcomics/ui/search.dart';
import 'settings.dart';
import 'helper.dart';
import 'library.dart';
import 'explore.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 2;
  bool isHovered = false; //is set to true if
  // late CupertinoNavigationBar searchInput;
  late MangaAggregate ma;

  late AnimationController _animationController; //animation related
  late Animation<double> _navBarWidth; //controls navbar expand animation

  List<Widget> homepage = [
    SizedBox(
      child: ExploreManga(),
    ),
    SizedBox(
      child: SearchManga(),
    ),
    SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SlideShow(mangaList: slideshowManga),
            const SizedBox(height: 30),
            MangaRow(title: "Latest Added Mangas", mangaList: latestManga),
            const SizedBox(height: 30),
            MangaRow(title: "Recently Updated Mangas", mangaList: updatedManga),
            const Padding(
                padding: EdgeInsets.all(kBottomNavigationBarHeight / 2)),
          ],
        ),
      ),
    ),
    (incognitoMode) ? (const LoginButton()) : (Library()),
    (incognitoMode) ? (const LoginButton()) : (const Settings()),
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _navBarWidth = Tween<double>(begin: 75, end: 200).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homepage[1] = SizedBox(
      child: SearchManga(),
    );
    // deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: (size.width <= 500)
          ? ((currentIndex == 1)
              ? (CupertinoNavigationBar(
                  trailing: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        if (isSearch) {
                          setState(() {
                            searchedManga.clear();
                            isSearch = false;
                          });
                        }
                      },
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        (isSearch)
                            ? (CupertinoIcons.xmark)
                            : (CupertinoIcons.search),
                        size: 24,
                      ),
                    ),
                  ),
                  leading: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              // deviceMode =
                              //     MediaQuery.of(context).orientation;
                              return Padding(
                                padding: EdgeInsets.all(
                                    ((size.width > 500) ? (10.0) : (0.0))),
                                child: Align(
                                  alignment: ((size.width > 500)
                                      ? (Alignment.center)
                                      : (Alignment.bottomCenter)),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: (size.width > 500)
                                          ? (500)
                                          : (size.width),
                                      height: (size.width > 500)
                                          ? (500)
                                          : (size.height * 0.68),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ExpandWidget(
                                              heading: "Format",
                                              child: Wrap(
                                                runSpacing: 5,
                                                spacing: 5,
                                                children: format.keys
                                                    .map(
                                                      (e) => Chip(
                                                        label: Text(
                                                          e,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              expanded: true,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ExpandWidget(
                                              heading: "Theme",
                                              child: Wrap(
                                                runSpacing: 5,
                                                spacing: 5,
                                                children: theme.keys
                                                    .map(
                                                      (e) => Chip(
                                                        label: Text(
                                                          e,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              expanded: true,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ExpandWidget(
                                              heading: "Genre",
                                              child: Wrap(
                                                runSpacing: 5,
                                                spacing: 5,
                                                children: genres.values
                                                    .map(
                                                      (e) => Chip(
                                                        label: Text(
                                                          e,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
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
                      icon: const Icon(
                        CupertinoIcons.slider_horizontal_3,
                        size: 24,
                      ),
                    ),
                  ),
                  middle: Material(
                    color: Colors.transparent,
                    child: TextField(
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
                            mangaSearching =
                                searchmanga(searchedManga.text, '50', '0');
                          });
                        } else {
                          setState(() {
                            mangaSearching.ignore();
                            isSearch = false;
                          });
                        }
                      },
                    ),
                  ),
                ))
              : (CupertinoNavigationBar(
                  middle: Image.asset(
                    "assets/images/logo.png",
                    width: 50,
                  ),
                )))
          : (null),
      floatingActionButton: (currentIndex == 0)
          ? (FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const RandomManga()));
              },
              child: const Icon(CupertinoIcons.gift_fill),
            ))
          : (null),
      body: Padding(
        padding: (size.width > 500)
            ? (const EdgeInsets.only(top: kTextTabBarHeight - 15))
            : (EdgeInsets.zero),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            (size.width > 500)
                ? MouseRegion(
                    onEnter: (event) {
                      _animationController.forward().whenComplete(
                            () => setState(() {
                              isHovered = true;
                            }),
                          );
                    },
                    onExit: (event) {
                      setState(() {
                        isHovered = false;
                      });
                      _animationController.reverse();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return SizedBox(
                                width: _navBarWidth.value,
                                child: (SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        child: Center(
                                          child: SizedBox(
                                            height: 75,
                                            width: 75,
                                            child: Image.asset(
                                                "assets/images/logo.png"),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ListTile(
                                        title: isHovered
                                            ? const Text("Search")
                                            : null,
                                        onTap: () {
                                          if (currentIndex != 1) {
                                            setState(() {
                                              currentIndex = 1;
                                            });
                                          }
                                        },
                                        leading: const Icon(
                                          CupertinoIcons.search,
                                        ),
                                      ),
                                      ListTile(
                                        title: isHovered
                                            ? const Text("Explore")
                                            : null,
                                        onTap: () {
                                          if (currentIndex != 0) {
                                            setState(() {
                                              currentIndex = 0;
                                            });
                                          }
                                        },
                                        leading: const Icon(
                                          CupertinoIcons.compass,
                                        ),
                                      ),
                                      ListTile(
                                        title: isHovered
                                            ? const Text("Library")
                                            : null,
                                        onTap: () {
                                          if (currentIndex != 3) {
                                            setState(() {
                                              currentIndex = 3;
                                            });
                                          }
                                        },
                                        leading: const Icon(
                                          CupertinoIcons.bookmark,
                                        ),
                                      ),
                                      ListTile(
                                        title: isHovered
                                            ? const Text("Settings")
                                            : null,
                                        onTap: () {
                                          if (currentIndex != 4) {
                                            setState(() {
                                              currentIndex = 4;
                                            });
                                          }
                                        },
                                        leading: const Icon(
                                          CupertinoIcons.settings,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              );
                            }),
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
                  (currentIndex == 1 && size.width > 500)
                      ? (CupertinoNavigationBar(
                          trailing: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                if (isSearch) {
                                  setState(() {
                                    searchedManga.clear();
                                    isSearch = false;
                                  });
                                }
                              },
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                (isSearch)
                                    ? (CupertinoIcons.xmark)
                                    : (CupertinoIcons.search),
                                size: 24,
                              ),
                            ),
                          ),
                          leading: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      // deviceMode =
                                      //     MediaQuery.of(context).orientation;
                                      return Padding(
                                        padding: EdgeInsets.all(
                                            ((size.width > 500)
                                                ? (10.0)
                                                : (0.0))),
                                        child: Align(
                                          alignment: ((size.width > 500)
                                              ? (Alignment.center)
                                              : (Alignment.bottomCenter)),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              width: (size.width > 500)
                                                  ? (500)
                                                  : (size.width),
                                              height: (size.width > 500)
                                                  ? (500)
                                                  : (size.height * 0.68),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ExpandWidget(
                                                      heading: "Format",
                                                      child: Wrap(
                                                        runSpacing: 5,
                                                        spacing: 5,
                                                        children: format.keys
                                                            .map(
                                                              (e) => Chip(
                                                                label: Text(
                                                                  e,
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                      expanded: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    ExpandWidget(
                                                      heading: "Theme",
                                                      child: Wrap(
                                                        runSpacing: 5,
                                                        spacing: 5,
                                                        children: theme.keys
                                                            .map(
                                                              (e) => Chip(
                                                                label: Text(
                                                                  e,
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                      expanded: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    ExpandWidget(
                                                      heading: "Genre",
                                                      child: Wrap(
                                                        runSpacing: 5,
                                                        spacing: 5,
                                                        children: genres.values
                                                            .map(
                                                              (e) => Chip(
                                                                label: Text(
                                                                  e,
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
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
                              icon: const Icon(
                                CupertinoIcons.slider_horizontal_3,
                                size: 24,
                              ),
                            ),
                          ),
                          middle: Material(
                            color: Colors.transparent,
                            child: TextField(
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
                                    mangaSearching = searchmanga(
                                        searchedManga.text, '50', '0');
                                  });
                                } else {
                                  setState(() {
                                    mangaSearching.ignore();
                                    isSearch = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ))
                      : (const SizedBox()),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all((size.width > 500) ? 10 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular((size.width > 500) ? 10 : 0)),
                        child: Container(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
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
      ),
      bottomNavigationBar: (size.width <= 500)
          ? SizedBox(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: (BottomNavigationBar(
                    elevation: 0,
                    currentIndex: currentIndex,
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.compass,
                        ),
                        label: "Explore",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.search,
                        ),
                        label: "Search",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.home,
                        ),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.bookmark,
                        ),
                        label: "Library",
                      ),
                      BottomNavigationBarItem(
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
