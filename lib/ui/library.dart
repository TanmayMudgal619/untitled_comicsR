import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/api/classes.dart';
import 'mangatile.dart';

class Library extends StatefulWidget {
  Library({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  void initState() {
    allStatus.addEntries(allComics.keys
        .toList()
        .map((e) => MapEntry(e, {
              "data": allComics[e],
              "off": 0,
              "loading": false,
              "loaded": <Manga>[],
              "next": true,
              "scroll": null,
            }))
        .toList());
    if (allComicsLoaded) {
      allStatus.entries.forEach((element) {
        element.value["scroll"] = ScrollController();
        if (element.value["data"] != null) {
          getmangalist(
                  element.value["data"].sublist(
                      0,
                      (element.value["data"].length - element.value["off"] >=
                              100)
                          ? (100)
                          : (null)),
                  '100')
              .then((value) {
            setState(() {
              element.value["loaded"].addAll(value);
              if (value.length < 100) {
                element.value["next"] = false;
              }
            });
          });
        } else {
          setState(() {
            print("else");
            element.value["next"] = false;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return SizedBox(
      child: DefaultTabController(
        length: allComics.keys.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: allComics.keys
                  .toList()
                  .map((e) => Tab(
                        child: Text(
                          e.replaceAll("_", " ").toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
            Flexible(
                fit: FlexFit.loose,
                child: TabBarView(
                  children: allStatus.values.toList().map((e) {
                    if (!allComicsLoaded) {
                      return const CircularProgressIndicator();
                    }
                    if (e["loaded"].isEmpty) {
                      if (e["next"]) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text("Nothing Here!");
                      }
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ((deviceMode == Orientation.landscape)
                                  ? (size.width - size.width * 0.3)
                                  : (size.width)) ~/
                              105,
                          childAspectRatio: 105 / 160,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: e["loaded"].length,
                        itemBuilder: (context, val) {
                          return MangaTile(manga: e["loaded"][val]);
                        });
                  }).toList(),
                )),
          ],
        ),
      ),
    );
  }
}
