import 'package:flutter/material.dart';
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
  Container(
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
  Container(
    child: const Text(
      "Library",
      style: TextStyle(color: Colors.white),
    ),
  ),
  Container(
    child: const Text(
      "Settings",
      style: TextStyle(color: Colors.white),
    ),
  ),
];
