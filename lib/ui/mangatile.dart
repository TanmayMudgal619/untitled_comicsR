import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'manga.dart';

class MangaTile extends StatelessWidget {
  Manga manga;
  MangaTile({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.white12, width: 2),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MangaPage(mangaOpened: manga)));
          },
          child: Container(
            width: 105,
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  manga.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              width: 105,
              height: 160,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1000)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: Colors.black45,
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: (manga.status == "ongoing")
                                ? (Colors.blueAccent)
                                : ((manga.status == "completed")
                                    ? (Colors.green)
                                    : ((manga.status == "hiatus")
                                        ? (Colors.orange)
                                        : (Colors.red))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    manga.title,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
