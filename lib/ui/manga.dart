import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/tags.dart';
import 'package:untitledcomics/ui/mangatile.dart';
import 'helper.dart';
import 'package:flutter/cupertino.dart';
import 'mangachapter.dart';

// late Orientation deviceMode;

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
  late Future<MangaStatistics> mangaStatisticsLoader;
  late MangaStatistics mangaStatistics;
  late Future<MangaAggregate> mangaAggregate;
  String mangaReadingStatus = "none";
  // double rating = 0.0;
  @override
  void initState() {
    if (login) {
      for (var status in allComics.entries) {
        if (status.value.contains(widget.mangaOpened.id)) {
          mangaReadingStatus = status.key;
        }
      }
    }
    mangaHeader = MangaHeader(
      manga: widget.mangaOpened,
      mangaReadingStatus: mangaReadingStatus,
    );

    mangaInfo = MangaInfo(
      manga: widget.mangaOpened,
    );

    mangaStatisticsLoader =
        getMangaStatistics(widget.mangaOpened.id).then((value) {
      setState(() {
        mangaStatistics = value;
        // rating = value.rating.toDouble();
      });
      return value;
    });

    basedManga = getmangalisttag(widget.mangaOpened.genrei,
        widget.mangaOpened.publicationDemographic, '25', widget.mangaOpened.id);

    mangaBased = MangaBased(
      basedManga: basedManga,
    );

    mangaPageChapter = MangaPageChapter(id: widget.mangaOpened.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          widget.mangaOpened.title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        trailing: FutureBuilder<MangaStatistics>(
          future: mangaStatisticsLoader,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Icon(
                    CupertinoIcons.circle_fill,
                    color: Colors.redAccent,
                    size: 16,
                  );
                } else {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 300,
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
                                            ListTile(
                                              title: const Text(
                                                "Total Rating",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                ),
                                                child: Text(
                                                  mangaStatistics.average
                                                      .toStringAsFixed(2),
                                                ),
                                              ),
                                            ),
                                            // (login)
                                            //     ? (ExpandWidget(
                                            //         heading: "My Rating",
                                            //         child: StatefulBuilder(
                                            //           builder: (context,
                                            //               setSliderState) {
                                            //             return Slider(
                                            //               divisions: 9,
                                            //               label:
                                            //                   rating.toString(),
                                            //               thumbColor:
                                            //                   Theme.of(context)
                                            //                       .primaryColor,
                                            //               activeColor:
                                            //                   Theme.of(context)
                                            //                       .primaryColor,
                                            //               inactiveColor:
                                            //                   Theme.of(context)
                                            //                       .primaryColor
                                            //                       .withOpacity(
                                            //                           0.4),
                                            //               value: (rating != 0)
                                            //                   ? (rating)
                                            //                   : (1),
                                            //               min: 1,
                                            //               max: 10,
                                            //               onChanged: (value) {
                                            //                 setSliderState(() {
                                            //                   rating = value;
                                            //                 });
                                            //               },
                                            //             );
                                            //           },
                                            //         ),
                                            //         expanded: false,
                                            //       ))
                                            //     : (const SizedBox(
                                            //         height: 0,
                                            //         width: 0,
                                            //       )),
                                            ExpandWidget(
                                              heading: "Ratings",
                                              child: Column(
                                                children: mangaStatistics
                                                    .distribution.entries
                                                    .map(
                                                      (e) => ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        title: Text(
                                                            ratingsLabel[
                                                                e.key]!),
                                                        trailing: Text(
                                                            e.value.toString()),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              expanded: false,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.star_border_rounded),
                    ),
                  );
                }
            }
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: (size.width > 500)
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
                    ),
                  ),
                ))
              ],
            )
          : SizedBox(
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
                ),
              ),
            ),
    );
  }
}

class MangaHeader extends StatefulWidget {
  Manga manga;
  String mangaReadingStatus;
  MangaHeader({Key? key, required this.manga, required this.mangaReadingStatus})
      : super(key: key);

  @override
  State<MangaHeader> createState() => _MangaHeaderState();
}

class _MangaHeaderState extends State<MangaHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.manga.cover,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.manga.cover,
                        width: 130,
                      ),
                      (login)
                          ? (Positioned(
                              right: 5,
                              top: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: InkWell(
                                    onLongPress: () {
                                      if (widget.mangaReadingStatus != "none") {
                                        setState(() {
                                          widget.mangaReadingStatus = "none";
                                          setReadingStatus(widget.manga.id,
                                              widget.mangaReadingStatus);
                                        });
                                      }
                                    },
                                    onTap: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: 300,
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
                                                        children: allComics.keys
                                                            .map(
                                                              (e) => ListTile(
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                dense: true,
                                                                leading: Radio(
                                                                  value: e,
                                                                  groupValue: widget
                                                                      .mangaReadingStatus,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      setReadingStatus(
                                                                        widget
                                                                            .manga
                                                                            .id,
                                                                        value
                                                                            .toString(),
                                                                      );
                                                                      if (widget
                                                                              .mangaReadingStatus !=
                                                                          "none") {
                                                                        allComics[widget.mangaReadingStatus]!
                                                                            .remove(
                                                                          widget
                                                                              .manga
                                                                              .id,
                                                                        );
                                                                      }
                                                                      widget.mangaReadingStatus =
                                                                          value
                                                                              .toString();
                                                                      if (value !=
                                                                          "none") {
                                                                        allComics[value]!.add(widget
                                                                            .manga
                                                                            .id);
                                                                      }
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                title: Text(
                                                                  e
                                                                      .replaceAll(
                                                                          "_",
                                                                          " ")
                                                                      .toUpperCase(),
                                                                ),
                                                              ),
                                                            )
                                                            .toList()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      ((widget.mangaReadingStatus == "dropped")
                                          ? (Icons.bookmark_remove_rounded)
                                          : ((widget.mangaReadingStatus ==
                                                  "re_reading")
                                              ? (Icons.bookmarks_rounded)
                                              : ((widget.mangaReadingStatus ==
                                                      "completed")
                                                  ? (Icons
                                                      .bookmark_added_rounded)
                                                  : (Icons.bookmark)))),
                                      size: 20,
                                      color: ((widget.mangaReadingStatus ==
                                              "reading")
                                          ? (Colors.blueAccent)
                                          : ((widget.mangaReadingStatus ==
                                                  "dropped")
                                              ? (Colors.deepOrangeAccent)
                                              : ((widget.mangaReadingStatus ==
                                                      "plan_to_read")
                                                  ? (Colors.lightBlueAccent)
                                                  : ((widget.mangaReadingStatus ==
                                                          "completed")
                                                      ? (Colors.green)
                                                      : ((widget.mangaReadingStatus ==
                                                              "re_reading")
                                                          ? (Colors.green)
                                                          : ((widget.mangaReadingStatus ==
                                                                  "on_hold")
                                                              ? (Colors.orange)
                                                              : (Colors
                                                                  .white))))))),
                                    )),
                              ),
                            ))
                          : (const SizedBox(
                              width: 0,
                              height: 0,
                            )),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.manga.title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.manga.authors.join(),
                        ),
                        Text(
                          widget.manga.artists.join(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text(
                          "Volume: ${(widget.manga.lastvolume.isEmpty) ? ('N/A') : (widget.manga.lastvolume)}",
                        ),
                        Text(
                          "Chapter: ${(widget.manga.lastchapter.isEmpty) ? ('N/A') : (widget.manga.lastchapter)}",
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
                                  color: (widget.manga.status == "ongoing")
                                      ? (Colors.blueAccent)
                                      : ((widget.manga.status == "completed")
                                          ? (Colors.green)
                                          : ((widget.manga.status == "hiatus")
                                              ? (Colors.orange)
                                              : (Colors.red))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    widget.manga.status.toUpperCase(),
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
                              widget.manga.publicationDemographic.toUpperCase(),
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
  MangaBody({
    Key? key,
    required this.tabs,
    required this.mangaInfo,
    required this.mangaChapters,
    required this.mangaBased,
  }) : super(key: key);

  @override
  _MangaBodyState createState() => _MangaBodyState();
}

class _MangaBodyState extends State<MangaBody> {
  late int currentIndex;
  @override
  Widget build(BuildContext context) {
    List<Widget> TabData = [];
    if (size.width <= 500) {
      TabData.add(SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(child: widget.mangaInfo),
        ),
      ));
    }
    TabData.addAll([
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget.mangaChapters,
        ),
      ),
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget.mangaBased,
        ),
      )
    ]);
    currentIndex = 0;
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
                height: (size.width > 500) ? (size.height) : (null),
                decoration: BoxDecoration(
                  borderRadius: (size.width > 500)
                      ? (const BorderRadius.all(Radius.circular(10)))
                      : (null),
                ),
                child: Column(
                  children: [
                    TabBar(
                      onTap: (value) {
                        setState(() {
                          currentIndex = value;
                        });
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
          expanded: true,
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
          expanded: true,
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
          expanded: true,
        )
      ],
    );
  }
}

class MangaBased extends StatefulWidget {
  final Future<List<Manga>> basedManga;
  const MangaBased({Key? key, required this.basedManga}) : super(key: key);

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
                  style: const TextStyle(color: Colors.white54),
                ),
              );
            }
            return GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ((size.width > 500)
                          ? (size.width - size.width * 0.35)
                          : (size.width)) ~/
                      160,
                  childAspectRatio: 160 / 200,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
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
