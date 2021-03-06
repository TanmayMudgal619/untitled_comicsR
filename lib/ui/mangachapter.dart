import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/ui/chapter.dart';

class MangaPageChapter extends StatefulWidget {
  final String id;
  late int offSet;
  late Future<List<MangaChapterData>> chapterLoader;
  bool next = true;
  bool prev = false;
  MangaPageChapter({Key? key, required this.id}) : super(key: key) {
    offSet = 0;
    chapterLoader = getChapters(id, 100, offSet, "asc", "asc");
  }

  @override
  Manga_ChaptPageerState createState() => Manga_ChaptPageerState();
}

class Manga_ChaptPageerState extends State<MangaPageChapter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaChapterData>>(
      future: widget.chapterLoader,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              if (snapshot.data!.isEmpty) {
                widget.next = false;
                return const Center(
                    child: Text("No Chapters for Selected Language!"));
              }
              if (snapshot.data!.length != 100) {
                widget.next = false;
              }
              List<Widget> show = snapshot.data!
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Chapter(
                                            chapter: e,
                                          )));
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.book,
                                    size: 80,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Scanlation Group: ${e.scg}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Volume: ${e.volume}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Chapter: ${e.chapter}',
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: const [
                                  Icon(
                                    CupertinoIcons.eye_fill,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList();
              show.add(
                Padding(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? (Colors.black87)
                            : (Colors.grey[100]!),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                        onPressed: (widget.prev)
                            ? (() {
                                setState(() {
                                  widget.offSet -= 100;
                                  if (widget.offSet == 0) {
                                    widget.prev = false;
                                  }
                                  widget.next = true;
                                  widget.chapterLoader = getChapters(widget.id,
                                      100, widget.offSet, "asc", "asc");
                                });
                              })
                            : (null),
                        icon: Icon(
                          CupertinoIcons.lessthan,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? (Colors.white)
                                  : (Colors.black),
                        ),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? (Colors.black87)
                            : (Colors.grey[100]!),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                        onPressed: (widget.next)
                            ? (() {
                                setState(() {
                                  widget.offSet += 100;
                                  widget.prev = true;
                                  widget.chapterLoader = getChapters(widget.id,
                                      100, widget.offSet, "asc", "asc");
                                });
                              })
                            : (null),
                        icon: Icon(
                          CupertinoIcons.greaterthan,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? (Colors.white)
                                  : (Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              return ListView(
                primary: false,
                children: show,
              );
            }
        }
      },
    );
  }
}
