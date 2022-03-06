import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'mangatile.dart';

class SearchManga extends StatefulWidget {
  SearchManga({Key? key}) : super(key: key);

  @override
  _SearchMangaState createState() => _SearchMangaState();
}

class _SearchMangaState extends State<SearchManga> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (searchedManga.text.isNotEmpty)
        ? (FutureBuilder<List<Manga>>(
            future: mangaSearching,
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
                          "Error Occurred While Searching! :)\n ${snapshot.error!.toString()}"),
                    );
                  } else {
                    return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ((size.width > 500)
                                  ? (size.width - size.width * 0.3)
                                  : (size.width)) ~/
                              105,
                          childAspectRatio: 105 / 160,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, val) {
                          return MangaTile(manga: snapshot.data![val]);
                        });
                  }
              }
            },
          ))
        : (const Center(
            child: Text("Search Manga Here....."),
          ));
  }
}
