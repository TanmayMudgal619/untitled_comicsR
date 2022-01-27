import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitledcomics/ui/library.dart';
import 'package:untitledcomics/ui/settings.dart';
import 'helper.dart';
import 'package:untitledcomics/globals/globals.dart';

List<Widget> potraitMode = [
  Container(
    child: const Text(
      "Explore",
      style: TextStyle(color: Colors.white),
    ),
  ),
  Container(
    child: const Text(
      "Search",
      style: TextStyle(color: Colors.white),
    ),
  ),
  SizedBox(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SlideShow(mangaList: slideshowManga),
          const Padding(padding: EdgeInsets.all(20)),
          MangaRow(title: "Latest Added Mangas", mangaList: latestManga),
          const Padding(padding: EdgeInsets.all(20)),
          MangaRow(title: "Recently Updated Mangas", mangaList: updatedManga),
        ],
      ),
    ),
  ),
  Library(),
  const Settings()
];
