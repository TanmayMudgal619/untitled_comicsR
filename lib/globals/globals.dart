import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitledcomics/api/classes.dart';
import 'user_choice.dart';

late User usr;
late final SharedPreferences sharedPreferences;
late Set<String> openHistory;
late Set<String> searchHistory;
late bool incognitoMode;
late bool login;
late bool dataSaver;
late String lang;
late List<Manga> latestManga;
late List<Manga> updatedManga;
late List<Manga> slideshowManga;
late Map<String, dynamic> library;

Map<String, List<String>> allComics = {
  "reading": [],
  "on_hold": [],
  "plan_to_read": [],
  "dropped": [],
  "re_reading": [],
  "completed": [],
  "none": [],
};
Map<String, Map<String, dynamic>> allStatus = {};

late Orientation deviceMode;
late Size size;

TextEditingController searchedManga = TextEditingController();
bool isSearch = false;
late Future<List<Manga>> mangaSearching;
