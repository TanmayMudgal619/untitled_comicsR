import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/api/classes.dart';
import 'package:untitledcomics/globals/globals.dart';

class Chapter extends StatefulWidget {
  final MangaChapterData chapter;
  const Chapter({Key? key, required this.chapter}) : super(key: key);

  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  late Future<GetChapterImg> images;
  @override
  void initState() {
    images = getchapterimage(widget.chapter.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          widget.chapter.title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        trailing: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: IconButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              setState(() {
                dataSaver = !dataSaver;
                sharedPreferences.setBool("dataSaver", dataSaver);
              });
            },
            icon: Icon(
                (dataSaver) ? (Icons.data_saver_on) : (Icons.data_saver_off)),
          ),
        ),
      ),
      body: FutureBuilder<GetChapterImg>(
        future: images,
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
                  child: Text("Error : ${snapshot.error.toString()}"),
                );
              } else {
                return ListView(
                  children: ((dataSaver)
                          ? (snapshot.data!.simages)
                          : (snapshot.data!.images))
                      .map(
                        (e) => CachedNetworkImage(
                            placeholder: (context, url) {
                              return Image.asset("assets/images/logo.png");
                            },
                            imageUrl:
                                "${snapshot.data!.baseUrl}/${(((dataSaver) ? ('data-saver') : ('data')))}/${snapshot.data!.hash}/$e"),
                      )
                      .toList(),
                );
              }
          }
        },
      ),
    );
  }
}
