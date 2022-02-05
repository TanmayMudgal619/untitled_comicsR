import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/login.dart';
import 'package:untitledcomics/ui/manga.dart';
import 'package:untitledcomics/ui/show.dart';
import 'mangatile.dart';

class MangaRow extends StatelessWidget {
  String title;
  List<Manga> mangaList;
  MangaRow({Key? key, required this.title, required this.mangaList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ShowManga(title: title, mangas: mangaList)));
                },
                icon: const Icon(
                  CupertinoIcons.forward,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 164,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: mangaList
                  .sublist(0, 10)
                  .map(
                    (e) => Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: MangaTile(manga: e)),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class SlideShow extends StatefulWidget {
  List<Manga> mangaList;
  SlideShow({Key? key, required this.mangaList}) : super(key: key);

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CarouselSlider(
        items: widget.mangaList
            .map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MangaPage(mangaOpened: e)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? (Colors.black26)
                                : (Colors.grey[200]!),
                            offset: const Offset(1, 2),
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Theme.of(context).canvasColor,
                          )
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      width: (deviceMode == Orientation.landscape)
                          ? (size.width * 0.6)
                          : (size.width * 0.9),
                      height: 200,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: e.cover,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.descm,
                                      overflow: TextOverflow.fade,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
        options: CarouselOptions(
          height: 210,
          enlargeCenterPage: true,
          autoPlay: true,
          viewportFraction: 0.85,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayInterval: const Duration(seconds: 5),
        ),
      ),
    );
  }
}

class ExpandWidget extends StatefulWidget {
  final String heading;
  final Widget child;
  bool expanded;
  ExpandWidget({
    Key? key,
    required this.heading,
    required this.child,
    required this.expanded,
  }) : super(key: key);

  @override
  _ExpandWidgetState createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(
              widget.heading,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    widget.expanded = !widget.expanded;
                  });
                },
                icon: Icon(
                  (widget.expanded)
                      ? (CupertinoIcons.chevron_up)
                      : (CupertinoIcons.chevron_down),
                )),
          ),
          (widget.expanded)
              ? (ListTile(
                  dense: true,
                  title: widget.child,
                ))
              : (const SizedBox(
                  width: 0,
                  height: 0,
                )),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        },
        child: Text(
          "Login First!",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      )),
    );
  }
}
