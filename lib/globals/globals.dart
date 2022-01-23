import 'package:flutter/cupertino.dart';
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
late List<Manga> latestManga;
late List<Manga> updatedManga;
late List<Manga> slideshowManga;
Map<String, List<String>> comicstatus = {
  "reading": [],
  "on_hold": [],
  "plan_to_read": [],
  "dropped": [],
  "re_reading": [],
  "completed": []
};
late Orientation deviceMode;
late Size size;
late Future<List<MangaChapterData>> chaptersLoading;
List<MangaChapterData> chaptersLoaded = [];
int offset = 0;
