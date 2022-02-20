import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/helper.dart';

void showmangaoverview(BuildContext context, Manga manga) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        deviceMode = MediaQuery.of(context).orientation;
        return Padding(
          padding: EdgeInsets.all(
              ((deviceMode == Orientation.landscape) ? (10.0) : (0.0))),
          child: Align(
            alignment: ((deviceMode == Orientation.landscape)
                ? (Alignment.center)
                : (Alignment.bottomCenter)),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: (deviceMode == Orientation.landscape)
                    ? (500)
                    : (size.width),
                height: (deviceMode == Orientation.landscape)
                    ? (500)
                    : (size.height * 0.68),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: manga.cover,
                                fit: BoxFit.cover,
                                width: 130,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                  : ((manga.status ==
                                                          "completed")
                                                      ? (Colors.green)
                                                      : ((manga.status ==
                                                              "hiatus")
                                                          ? (Colors.orange)
                                                          : (Colors.red))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                manga.status.toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 11),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          manga.publicationDemographic
                                              .toUpperCase(),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ExpandWidget(
                        heading: "Description",
                        child: Text(manga.descm),
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
                                                  const EdgeInsets.fromLTRB(
                                                      10, 7, 10, 7),
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
                                                  const EdgeInsets.fromLTRB(
                                                      10, 7, 10, 7),
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
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
