import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/mangaoverview.dart';
import 'manga.dart';

class MangaTile extends StatefulWidget {
  final Manga manga;
  const MangaTile({Key? key, required this.manga}) : super(key: key);

  @override
  State<MangaTile> createState() => _MangaTileState();
}

class _MangaTileState extends State<MangaTile>
    with SingleTickerProviderStateMixin {
  bool mouseEntered = false;
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? (Colors.black26)
                : (Colors.grey[200]!),
            offset: const Offset(1, 1),
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        MangaPage(mangaOpened: widget.manga)));
          },
          onDoubleTap: () {
            showmangaoverview(context, widget.manga);
          },
          child: Container(
            // width: 105,
            // height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.manga.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              width: 160,
              height: 200,
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: MouseRegion(
                            onEnter: (event) {
                              setState(() {
                                mouseEntered = true;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                mouseEntered = false;
                              });
                            },
                            child: AnimatedContainer(
                              height: 20,
                              width: mouseEntered ? 150 : 20,
                              duration: const Duration(milliseconds: 200),
                              child: mouseEntered
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color:
                                            (widget.manga.status == "ongoing")
                                                ? (Colors.blueAccent)
                                                : ((widget.manga.status ==
                                                        "completed")
                                                    ? (Colors.green)
                                                    : ((widget.manga.status ==
                                                            "hiatus")
                                                        ? (Colors.orange)
                                                        : (Colors.red))),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.manga.status,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.circle,
                                      size: 20,
                                      color: (widget.manga.status == "ongoing")
                                          ? (Colors.blueAccent)
                                          : ((widget.manga.status ==
                                                  "completed")
                                              ? (Colors.green)
                                              : ((widget.manga.status ==
                                                      "hiatus")
                                                  ? (Colors.orange)
                                                  : (Colors.red))),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.manga.title,
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
