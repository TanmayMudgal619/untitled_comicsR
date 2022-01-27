import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/ui/mangatile.dart';
import 'helper.dart';
import 'package:flutter/cupertino.dart';
import 'mangachapter.dart';

class MangaPage extends StatefulWidget {
  final Manga mangaOpened;
  const MangaPage({Key? key, required this.mangaOpened}) : super(key: key);

  @override
  _MangaPageState createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late MangaHeader mangaHeader;
  late MangaInfo mangaInfo;
  late MangaBased mangaBased;
  late Future<List<Manga>> basedManga;
  late MangaPageChapter mangaPageChapter;
  int currentIndexL = 0;
  int currentIndexP = 0;
  @override
  void initState() {
    mangaHeader = MangaHeader(manga: widget.mangaOpened);

    mangaInfo = MangaInfo(
      manga: widget.mangaOpened,
    );

    basedManga = getmangalisttag(widget.mangaOpened.genrei,
        widget.mangaOpened.publicationDemographic, '25');

    mangaBased = MangaBased(
      basedManga: basedManga,
    );

    mangaPageChapter = MangaPageChapter(id: widget.mangaOpened.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          widget.mangaOpened.title,
        ),
      ),
      body: (deviceMode == Orientation.landscape)
          ? Row(
              children: [
                (Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 350,
                      child: Drawer(
                        child: ListView(
                          primary: false,
                          children: [
                            mangaHeader,
                            const Padding(padding: EdgeInsets.all(5)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: mangaInfo,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: MangaBody(
                      tabs: const ["Chapter", "Based"],
                      mangaInfo: mangaInfo,
                      mangaChapters: mangaPageChapter,
                      mangaBased: mangaBased,
                      currentIndexL: currentIndexL,
                      currentIndexP: currentIndexP,
                    ),
                  ),
                ))
              ],
            )
          : Container(
              width: size.width,
              child: NestedScrollView(
                headerSliverBuilder: (context, val) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                        ),
                        child: mangaHeader,
                      ),
                    ),
                  ];
                },
                body: MangaBody(
                  tabs: const ["Info", "Chapters", "Based"],
                  mangaInfo: mangaInfo,
                  mangaChapters: mangaPageChapter,
                  mangaBased: mangaBased,
                  currentIndexL: currentIndexL,
                  currentIndexP: currentIndexP,
                ),
              ),
            ),
    );
  }
}

class MangaHeader extends StatelessWidget {
  Manga manga;
  MangaHeader({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                manga.cover,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (Theme.of(context).brightness == Brightness.light)
                    ? ([Colors.white, Colors.white38, Colors.white])
                    : ([
                        const Color(0xFF191A1C),
                        Colors.black26,
                        const Color(0xFF191A1C)
                      ]),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: manga.cover,
                    width: 130,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manga.title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          manga.authors.join(),
                        ),
                        Text(
                          manga.artists.join(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text(
                          "Volume: ${(manga.lastvolume.isEmpty) ? ('N/A') : (manga.lastvolume)}",
                        ),
                        Text(
                          "Chapter: ${(manga.lastchapter.isEmpty) ? ('N/A') : (manga.lastchapter)}",
                        ),
                        const Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(1000),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            color: Colors.white38,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: (manga.status == "ongoing")
                                      ? (Colors.blueAccent)
                                      : ((manga.status == "completed")
                                          ? (Colors.green)
                                          : ((manga.status == "hiatus")
                                              ? (Colors.orange)
                                              : (Colors.red))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    manga.status.toUpperCase(),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white38,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              manga.publicationDemographic.toUpperCase(),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MangaBody extends StatefulWidget {
  List<String> tabs;
  MangaInfo mangaInfo;
  Widget mangaChapters;
  MangaBased mangaBased;
  int currentIndexL;
  int currentIndexP;
  MangaBody(
      {Key? key,
      required this.tabs,
      required this.mangaInfo,
      required this.mangaChapters,
      required this.mangaBased,
      required this.currentIndexL,
      required this.currentIndexP})
      : super(key: key);

  @override
  _MangaBodyState createState() => _MangaBodyState();
}

class _MangaBodyState extends State<MangaBody> {
  late int currentIndex;
  @override
  Widget build(BuildContext context) {
    List<Widget> TabData = [];
    if (deviceMode == Orientation.portrait) {
      TabData.add(Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(child: widget.mangaInfo),
        ),
      ));
    }
    TabData.addAll([
      Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget.mangaChapters,
        ),
      ),
      Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget.mangaBased,
        ),
      )
    ]);
    currentIndex = (deviceMode == Orientation.landscape)
        ? (widget.currentIndexL)
        : (widget.currentIndexP);
    return DefaultTabController(
      initialIndex: currentIndex,
      length: widget.tabs.length,
      child: Container(
        color: (Theme.of(context).brightness == Brightness.dark)
            ? (Colors.black12)
            : (Colors.white),
        child: Column(
          children: [
            Flexible(
              child: Container(
                // width: size.width * 0.9,
                height: (deviceMode == Orientation.landscape)
                    ? (size.height)
                    : (null),
                decoration: BoxDecoration(
                  borderRadius: (deviceMode == Orientation.landscape)
                      ? (BorderRadius.all(Radius.circular(10)))
                      : (null),
                ),
                child: Column(
                  children: [
                    TabBar(
                      onTap: (value) {
                        if (deviceMode == Orientation.landscape) {
                          widget.currentIndexL = value;
                          widget.currentIndexP = (value == 0) ? 1 : 2;
                        } else {
                          widget.currentIndexP = value;
                          if (value != 0) {
                            widget.currentIndexL = (value == 1) ? 0 : 1;
                          } else {
                            widget.currentIndexL = 0;
                          }
                        }
                      },
                      tabs: widget.tabs
                          .map((e) => Tab(
                                child: Text(e),
                              ))
                          .toList(),
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                    Flexible(child: TabBarView(children: TabData))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaInfo extends StatelessWidget {
  final Manga manga;
  const MangaInfo({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandWidget(
          heading: "Description",
          child: Text(
            manga.desc,
            style: const TextStyle(color: Color(0xffaeaeae)),
          ),
        ),
        ExpandWidget(
          heading: "Genere",
          child: (manga.genre.isEmpty)
              ? (const Text("Nothing Here!"))
              : (SizedBox(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 1,
                    children: manga.genre
                        .map((e) => Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              color: Colors.white12,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                child: Text(
                                  e,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )),
        ),
        ExpandWidget(
          heading: "Theme",
          child: (manga.theme.isEmpty)
              ? (const Text(
                  "Nothing Here!",
                ))
              : (SizedBox(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 1,
                    children: manga.theme
                        .map((e) => Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              color: Colors.white12,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                child: Text(
                                  e,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )),
        )
      ],
    );
  }
}

class MangaBased extends StatefulWidget {
  Future<List<Manga>> basedManga;
  MangaBased({Key? key, required this.basedManga}) : super(key: key);

  @override
  State<MangaBased> createState() => _MangaBasedState();
}

class _MangaBasedState extends State<MangaBased> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return FutureBuilder<List<Manga>>(
      future: widget.basedManga,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }
            return GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ((deviceMode == Orientation.landscape)
                          ? (size.width - size.width * 0.46)
                          : (size.width)) ~/
                      105,
                  childAspectRatio: 105 / 160,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, val) {
                  return MangaTile(manga: snapshot.data![val]);
                });
        }
      },
    );
  }
}
