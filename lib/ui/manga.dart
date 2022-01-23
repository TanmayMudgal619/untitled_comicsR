// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/ui/mangatile.dart';
import 'helper.dart';
import 'package:flutter/cupertino.dart';

int currentIndexL = 0;
int currentIndexP = 0;

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
  MangaChapter mangaChapters = MangaChapter();

  @override
  void initState() {
    currentIndexL = 0;
    currentIndexP = 0;

    mangaHeader = MangaHeader(manga: widget.mangaOpened);

    mangaInfo = MangaInfo(
      manga: widget.mangaOpened,
    );

    chaptersLoading =
        getChapters(widget.mangaOpened.id, 100, offset, "asc", "asc", "en");

    basedManga = getmangalisttag(widget.mangaOpened.genrei,
        widget.mangaOpened.publicationDemographic, '20');

    mangaBased = MangaBased();

    super.initState();
  }

  @override
  void dispose() {
    chaptersLoaded.clear();
    offset = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          child: CachedNetworkImage(
            imageUrl: widget.mangaOpened.cover,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.black54,
            middle: Text(
              widget.mangaOpened.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: (deviceMode == Orientation.landscape)
              ? Row(
                  children: [
                    (Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 350,
                            child: Drawer(
                              backgroundColor: Colors.black26,
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
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: MangaBody(
                              tabs: const ["Chapter", "Based"],
                              mangaInfo: mangaInfo,
                              mangaChapters: mangaChapters),
                        ),
                      ),
                    ))
                  ],
                )
              : Container(
                  width: size.width,
                  color: Colors.black26,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                          mangaChapters: mangaChapters),
                    ),
                  ),
                ),
        )
      ],
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
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    manga.authors.join(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    manga.artists.join(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(3),
                  ),
                  Text(
                    "Volume: ${(manga.lastvolume.isEmpty) ? ('N/A') : (manga.lastvolume)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Volume: ${(manga.lastchapter.isEmpty) ? ('N/A') : (manga.lastchapter)}",
                    style: const TextStyle(color: Colors.white),
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
                      color: Colors.black38,
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
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MangaBody extends StatefulWidget {
  List<String> tabs;
  MangaInfo mangaInfo;
  Widget mangaChapters;
  MangaBody(
      {Key? key,
      required this.tabs,
      required this.mangaInfo,
      required this.mangaChapters})
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
      TabData.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(child: widget.mangaInfo),
      ));
    }
    TabData.addAll([
      Container(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget.mangaChapters,
        ),
      ),
      Container(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MangaBased(),
        ),
      )
    ]);
    currentIndex = (deviceMode == Orientation.landscape)
        ? (currentIndexL)
        : (currentIndexP);
    return DefaultTabController(
      initialIndex: currentIndex,
      length: widget.tabs.length,
      child: Column(
        children: [
          Flexible(
            child: Container(
              // width: size.width * 0.9,
              height: (deviceMode == Orientation.landscape)
                  ? (size.height)
                  : (null),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  TabBar(
                    onTap: (value) {
                      if (deviceMode == Orientation.landscape) {
                        currentIndexL = value;
                        currentIndexP = (value == 0) ? 1 : 2;
                      } else {
                        currentIndexP = value;
                        if (value != 0) {
                          currentIndexL = (value == 1) ? 0 : 1;
                        } else {
                          currentIndexL = 0;
                        }
                      }
                    },
                    tabs: widget.tabs
                        .map((e) => Tab(
                              child: Text(e),
                            ))
                        .toList(),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                  ),
                  Flexible(child: TabBarView(children: TabData))
                ],
              ),
            ),
          ),
        ],
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
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        ExpandWidget(
          heading: "Genere",
          child: Container(
            child: Wrap(
              spacing: 3,
              runSpacing: 1,
              children: manga.genre
                  .map((e) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Text(
                            e,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        ExpandWidget(
          heading: "Theme",
          child: (manga.theme.isEmpty)
              ? (Text(
                  "Nothing Here!",
                  style: TextStyle(color: Colors.white70),
                ))
              : (Container(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 1,
                    children: manga.theme
                        .map((e) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              color: Colors.black12,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
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
  const MangaBased({Key? key}) : super(key: key);

  @override
  State<MangaBased> createState() => _MangaBasedState();
}

class _MangaBasedState extends State<MangaBased> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return FutureBuilder<List<Manga>>(
      future: basedManga,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
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
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ((deviceMode == Orientation.landscape)
                          ? (size.width - size.width * 0.35)
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

class MangaChapter extends StatelessWidget {
  const MangaChapter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaChapterData>>(
      future: chaptersLoading,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (chaptersLoaded.length == offset) {
                chaptersLoaded.addAll(snapshot.data!);
                offset += 100;
              }
              if (chaptersLoaded.isEmpty) {
                return Center(
                  child: Text(
                    "No Chapters For Translated Language!",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return ListView(
                children: chaptersLoaded
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {},
                              title: Text(
                                (e.title.isEmpty)
                                    ? ("Chapter ${e.chapter}")
                                    : (e.title),
                                style: TextStyle(color: Colors.white),
                              ),
                              isThreeLine: true,
                              subtitle: Text(
                                "Chapter: ${e.chapter}\nVolume: ${e.volume}",
                                style: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
            }
        }
      },
    );
  }
}
