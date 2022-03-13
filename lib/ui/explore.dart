import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitledcomics/globals/tags.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/show.dart';
import 'mangatile.dart';

class ExploreManga extends StatefulWidget {
  late Future<Map<String, Set<Manga>>> exploreManga;
  ExploreManga({Key? key}) : super(key: key) {
    exploreManga = expl();
  }

  @override
  _ExploreMangaState createState() => _ExploreMangaState();
}

class _ExploreMangaState extends State<ExploreManga> {
  @override
  Widget build(BuildContext context) {
    // deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return FutureBuilder<Map<String, Set<Manga>>>(
      future: widget.exploreManga,
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
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: snapshot.data!.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    genres[e.key]!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                (e.value.length > 9)
                                    ? (IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ShowManga(
                                                title: genres[e.key]!,
                                                mangas: e.value.toList(),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.forward,
                                        ),
                                      ))
                                    : (const SizedBox(
                                        width: 0,
                                        height: 0,
                                      )),
                              ],
                            ),
                          ),
                          GV(
                            mangaGV: (e.value.length > 9)
                                ? (e.value.toList().sublist(0, 9))
                                : (e.value.toList()),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
        }
      },
    );
  }
}

class GV extends StatelessWidget {
  final List<Manga> mangaGV;
  const GV({Key? key, required this.mangaGV}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ((size.width > 500)
                  ? (size.width - size.width * 0.3)
                  : (size.width)) ~/
              160,
          childAspectRatio: 160 / 200,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: mangaGV.length,
        itemBuilder: (context, val) {
          return MangaTile(
            manga: mangaGV[val],
          );
        });
  }
}
