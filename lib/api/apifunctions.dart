import 'dart:io';

import 'classes.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:untitledcomics/globals/user_choice.dart';
import 'package:untitledcomics/globals/globals.dart';

Future<Manga> getmanga(var id) async {
  var url = Uri.http("api.mangadex.org", "/manga/$id", {
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    return Manga.fromJson(jsonR);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<Manga>> getmangalist(List<String> ids, var limit) async {
  var url = Uri.http("api.mangadex.org", "/manga", {
    "ids[]": ids,
    "limit": limit,
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<Manga> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(Manga.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<Manga>> getmangalisttag(
    List<String> ids, var demo, var limit) async {
  var url;
  if (demo != "null") {
    url = Uri.http("api.mangadex.org", "/manga", {
      "includedTags[]": ids,
      "publicationDemographic[]": demo,
      "limit": limit,
      "includedTagsMode": "OR",
      "includes[]": ["author", "artist", "cover_art"],
    });
  } else {
    url = Uri.http("api.mangadex.org", "/manga", {
      "includedTags[]": ids,
      "limit": limit,
      "includes[]": ["author", "artist", "cover_art"],
      "includedTagsMode": "OR",
    });
  }
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<Manga> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(Manga.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<Manga>> searchmanga(var title, var limit, var offset) async {
  // List a = [
  //   (globals.csafe) ? ("safe") : (null),
  //   (globals.csugs) ? ("suggestive") : (null),
  //   (globals.cpor) ? ("pornographic") : (null),
  //   (globals.cero) ? ("erotica") : (null),
  // ];
  // a.removeWhere((element) => element == null);
  var url = Uri.http("api.mangadex.org", "/manga", {
    "title": title,
    "limit": limit.toString(),
    "offset": offset.toString(),
    "includes[]": ["author", "artist", "cover_art"],
    // "contentRating[]": a,
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<Manga> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(Manga.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<Manga> randommanga() async {
  var url = Uri.http("api.mangadex.org", "/manga/random", {
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    return Manga.fromJson(json.decode(response.body)["data"]);
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<String> getcover(var id) async {
  var url = Uri.http("api.mangadex.org", "/cover/$id");
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    for (var i in jsonR["relationships"]) {
      if (i["type"] == "manga") {
        return "https://uploads.mangadex.org/covers/${i["id"]}/${jsonR["data"]["attributes"]["fileName"]}";
      }
    }
    throw Exception("Cover Relation Not Found!");
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<GetChapterImg> getchapterimage(String id) async {
  var url = Uri.http("api.mangadex.org", "/chapter/$id");
  var surl = Uri.http("api.mangadex.org", "/at-home/server/$id");
  var response = await https.get(url);
  var sresponse = await https.get(surl);
  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body)["data"]["attributes"];
    var baseUrl = jsonDecode(sresponse.body)["baseUrl"];
    return GetChapterImg(baseUrl, jsondata["data"], jsondata["dataSaver"]);
  } else {
    throw Exception("Not Able to Load Images");
  }
}

Future<List<List<Manga>>> homeload() async {
  List<String> a = [
    '32d76d19-8a05-4db0-9fc2-e0b0648fe9d0',
    'c80873ba-a29c-4285-9e3b-9b2b03be3d65',
    '6e3553b9-ddb5-4d37-b7a3-99998044774e',
    '02f0f46c-3c5e-4338-b20b-ee782cc11932',
    'e4429b48-f543-47cd-ad2d-39e73ab264e5',
    'be6e00ba-27da-4d7c-8489-8518935e9ad4',
    '922d3987-3cb9-4c42-a510-db10795cafc0',
    'd8a959f7-648e-4c8d-8f23-f1f3f8e129f3',
    '1caae7cb-9e28-48c4-96a2-9a24ead822ff',
    '5bbc4409-59eb-4388-8c35-149b19b468f1',
    'c5e951db-57fa-4caf-abea-6624b98c4716',
    'bbaa17c4-0f36-4bbb-9861-34fc8fdf20fc',
    '4c86f38a-cead-4575-a9c3-acf7261a58ff',
  ];
  var s = Uri.http("api.mangadex.org", "/manga", {
    "ids[]": a,
    "limit": "100",
    "includes[]": ["author", "artist", "cover_art"],
  });
  var top = Uri.http("api.mangadex.org", "/manga", {
    "limit": '50',
    "offset": '0',
    "includes[]": ["author", "artist", "cover_art"],
  });
  var newm = Uri.http("api.mangadex.org", "/manga", {
    "limit": '50',
    "offset": '0',
    "order[createdAt]": "desc",
    "includes[]": ["author", "artist", "cover_art"],
  });
  var responses =
      await Future.wait([https.get(top), https.get(newm), https.get(s)]);
  if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
    var jsonT = jsonDecode(responses[0].body);
    var jsons = jsonDecode(responses[2].body);
    var jsonN = jsonDecode(responses[1].body);
    List<Manga> tdata = [];
    List<Manga> sdata = [];
    List<Manga> ndata = [];
    for (var i in jsons["data"]) {
      sdata.add(Manga.fromJson(i));
    }
    for (var i in jsonT["data"]) {
      tdata.add(Manga.fromJson(i));
    }
    for (var i in jsonN["data"]) {
      ndata.add(Manga.fromJson(i));
    }
    return [tdata, ndata, sdata];
  } else {
    throw Exception(
        "Error Code : ${responses[0].statusCode}/${responses[1].statusCode}");
  }
}

Future<List<MangaChapterData>> getChapters(String id, int limit, int offset,
    String orderc, String orderv, String lang) async {
  var url;
  if (lang == 'any') {
    url = Uri.https("api.mangadex.org", "/manga/$id/feed", {
      "limit": limit.toString(),
      "offset": offset.toString(),
      "order[volume]": orderv,
      "order[chapter]": orderc,
      "includes[]": "scanlation_group"
    });
  } else {
    url = Uri.https("api.mangadex.org", "/manga/$id/feed", {
      "limit": limit.toString(),
      "offset": offset.toString(),
      "order[volume]": orderv,
      "order[chapter]": orderc,
      "translatedLanguage[]	": lang,
      "includes[]": "scanlation_group"
    });
  }
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return (jsonResponse["data"] as List).map((e) {
      return MangaChapterData.fromJson(e);
    }).toList();
  } else {
    throw Exception("Can't Load Chapters!");
  }
}

// Future<Map<String, Set<Manga>>> expl(int off) async {
//   int a = Random().nextInt(10000 - 200);
//   int b = Random().nextInt(10000 - 200);
//   b = (a == b) ? (a + 100) : (b);
//   var url = Uri.http("api.mangadex.org", "/manga", {
//     "limit": '100',
//     "offset": a.toString(),
//     "includes[]": ["author", "artist", "cover_art"],
//   });
//   var urla = Uri.http("api.mangadex.org", "/manga", {
//     "limit": '100',
//     "offset": b.toString(),
//     "includes[]": ["author", "artist", "cover_art"],
//   });
//   var response = await Future.wait([https.get(url), https.get(urla)]);
//   if (response[0].statusCode == 200 && response[1].statusCode == 200) {
//     var jsona = jsonDecode(response[0].body);
//     var jsonb = jsonDecode(response[1].body);
//     Map<String, Set<Manga>> maind = {};
//     for (var i in jsona["data"]) {
//       var e = Manga.fromJson(i);
//       for (var j in e.genrei) {
//         if (maind[j] != null) {
//           maind[j]!.add(e);
//         } else {
//           maind[j] = {e};
//         }
//       }
//     }
//     for (var i in jsonb["data"]) {
//       var e = Manga.fromJson(i);
//       for (var j in e.genrei) {
//         if (maind[j] != null) {
//           maind[j]!.add(e);
//         } else {
//           maind[j] = {e};
//         }
//       }
//     }
//     return maind;
//   } else {
//     throw Exception("Error!");
//   }
// }

Future<String> follow(String id, User usr) async {
  usr.refreshSession();
  var url = Uri.https("api.mangadex.org", "/manga/$id/follow");
  var response = await https.post(url,
      headers: {HttpHeaders.authorizationHeader: "Bearer ${usr.sessionToken}"});
  if (response.statusCode == 200) {
    return "OK";
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> loginUser(var username, var password) async {
  var url = Uri.https("api.mangadex.org", "auth/login");
  var response = await https.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }));
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    return jsonR["token"];
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> getlibrary() async {
  await usr.refreshSession();
  var url = Uri.https("api.mangadex.org", "/manga/status/");
  var response = await https.get(
    url,
    headers: {HttpHeaders.authorizationHeader: "Bearer ${usr.sessionToken}"},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)["statuses"];
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> getMangaRating(String id) async {
  var url = Uri.https("api.mangadex.org", "/statistics/manga/$id");
  var response = await https.get(url);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)["statistics"][id]["rating"];
  } else {
    throw Exception("Error ${response.statusCode}");
  }
}
