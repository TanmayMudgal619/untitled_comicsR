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
    allStatus.entries.forEach((element) {
      element.value["scroll"] = ScrollController();
      element.value["scroll"].addListener(() {
        if ((element.value["scroll"].offset >=
                element.value["scroll"].position.maxScrollExtent) &&
            !element.value["scroll"].position.outOfRange &&
            element.value["next"] &&
            !element.value["loading"]) {
          if (mounted) {
            setState(() {
              element.value["loading"] = true;
              element.value["off"] += 100;
              getmangalist(
                      element.value["data"].sublist(
                          element.value["off"],
                          (element.value["data"].length -
                                      element.value["off"] >=
                                  100)
                              ? (100)
                              : (null)),
                      '100')
                  .then((value) {
                if (mounted) {
                  setState(() {
                    element.value["loaded"].addAll(value);
                    element.value["loading"] = false;
                    if (value.length < 100) {
                      element.value["next"] = false;
                    }
                  });
                }
              });
            });
          }
        }
      });
      if (element.value["data"] != null) {
        element.value["loading"] = true;
        getmangalist(
                element.value["data"].sublist(
                    0,
                    (element.value["data"].length - element.value["off"] >= 100)
                        ? (100)
                        : (null)),
                '100')
            .then((value) {
          if (mounted) {
            setState(() {
              element.value["loading"] = false;
              element.value["loaded"].addAll(value);
              if (value.length < 100) {
                element.value["next"] = false;
              }
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            element.value["next"] = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // deviceMode = MediaQuery.of(context).orientation;
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
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
                fit: FlexFit.loose,
                child: TabBarView(
                  children: allStatus.values.toList().map((e) {
                    if (e["loaded"].isEmpty) {
                      if (e["next"]) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Text("Nothing Here!");
                      }
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        controller: e["scroll"],
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ((size.width > 500)
                                  ? (size.width - size.width * 0.3)
                                  : (size.width)) ~/
                              160,
                          childAspectRatio: 160 / 200,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
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
