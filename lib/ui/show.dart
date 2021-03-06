import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'mangatile.dart';

class ShowManga extends StatefulWidget {
  final String title;
  final List<Manga> mangas;
  const ShowManga({Key? key, required this.title, required this.mangas})
      : super(key: key);

  @override
  _ShowMangaState createState() => _ShowMangaState();
}

class _ShowMangaState extends State<ShowManga> {
  @override
  Widget build(BuildContext context) {
    // deviceMode = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size.width ~/ 160,
              childAspectRatio: 160 / 200,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemCount: widget.mangas.length,
            itemBuilder: (context, val) {
              return MangaTile(manga: widget.mangas[val]);
            }),
      ),
    );
  }
}
