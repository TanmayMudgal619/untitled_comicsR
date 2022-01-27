class Manga {
  String id;
  String title;
  String cover;
  String descm;
  String desc;
  String language;
  String lastvolume;
  String lastchapter;
  String status;
  List<dynamic> authors;
  List<dynamic> artists;
  String publicationDemographic;
  List<String> genre;
  List<String> genrei;
  List<String> theme;
  Manga({
    required this.id,
    required this.title,
    required this.cover,
    required this.descm,
    required this.desc,
    required this.language,
    required this.lastvolume,
    required this.lastchapter,
    required this.status,
    required this.authors,
    required this.artists,
    required this.publicationDemographic,
    required this.genre,
    required this.genrei,
    required this.theme,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    json["author"] = [];
    json["artist"] = [];
    var de = json["attributes"]["description"];
    var dm = (de.toString() == "[]")
        ? ("Read & Find!")
        : (((de["en"] == null)
            ? (de[de.entries.toList()[0].key])
            : (de["en"])));
    var d = (de.toString() == "[]")
        ? ("Read & Find!")
        : (de.values.reduce((e, f) => e + "\n\n" + f));
    for (var i in json["relationships"]) {
      if (i["type"] == "cover_art") {
        json["cover"] =
            "https://uploads.mangadex.org/covers/${json["id"]}/${i["attributes"]["fileName"]}.256.jpg";
      } else {
        if (json[i["type"]] == null) {
          if (i["attributes"] != null)
            json[i["type"]] = [i["attributes"]["name"]];
          else
            json[i["type"]] = [i["attributes"].toString()];
        } else {
          if (i["attributes"] != null)
            json[i["type"]].add(i["attributes"]["name"]);
          else
            json[i["type"]].add(i["attributes"].toString());
        }
      }
    }
    if (json["cover"] == null)
      json["cover"] =
          "https://mangadex.org/_nuxt/img/cover-placeholder.d12c3c5.jpg";
    List<String> g = [];
    List<String> t = [];
    List<String> gi = [];
    for (var i in json["attributes"]["tags"]) {
      var j = i["attributes"];
      if (j["group"] == "genre") {
        gi.add(i["id"]);
        g.add(j["name"]["en"]);
      } else if (j["group"] == "theme") {
        t.add(j["name"]["en"]);
      }
    }
    return Manga(
      id: json["id"],
      title: json["attributes"]["title"]
          [json["attributes"]["title"].entries.toList()[0].key],
      cover: json["cover"],
      descm: dm,
      desc: d,
      language: json["attributes"]["originalLanguage"],
      lastvolume: json["attributes"]["lastVolume"].toString(),
      lastchapter: json["attributes"]["lastChapter"].toString(),
      publicationDemographic:
          json["attributes"]["publicationDemographic"].toString(),
      status: json["attributes"]["status"],
      authors: json["author"],
      artists: json["artist"],
      genre: g,
      genrei: gi,
      theme: t,
    );
  }
}

class MangaChapterData {
  String id;
  String title;
  String lang;
  String chapter;
  String volume;
  String scg;
  MangaChapterData(
      {required this.id,
      required this.title,
      required this.lang,
      required this.chapter,
      required this.volume,
      required this.scg});

  factory MangaChapterData.fromJson(Map<String, dynamic> json) {
    String scg = "";
    for (var i in json["relationships"]) {
      if (i["type"] == "scanlation_group") {
        scg = i["attributes"]["name"];
      }
    }
    return MangaChapterData(
        id: json['id'],
        title: json['attributes']['title'].toString(),
        lang: json['attributes']['translatedLanguage'].toString(),
        chapter: json['attributes']['chapter'].toString(),
        volume: json['attributes']['volume'].toString(),
        scg: scg);
  }
}

class GetChapterImg {
  final String baseUrl;
  final List<dynamic> images;
  final List<dynamic> simages;
  GetChapterImg(this.baseUrl, this.images, this.simages);
}
