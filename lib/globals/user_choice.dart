import 'dart:io';
import 'package:http/http.dart' as https;
import 'dart:convert';

import 'package:untitledcomics/globals/globals.dart';

class User {
  String username;
  String sessionToken;
  String refreshToken;
  DateTime lastToken;

  User(this.username, this.sessionToken, this.refreshToken, this.lastToken);

  Future<void> refreshSession() async {
    if (DateTime.now().isBefore(lastToken.add(const Duration(minutes: 4)))) {
      return;
    }
    var url = Uri.https("api.mangadex.org", "/auth/refresh");
    var response = await https.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(
        {
          "token": refreshToken,
        },
      ),
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)["token"];
      sessionToken = json["session"];
      refreshToken = json["refresh"];
      sharedPreferences.setString("session", sessionToken);
      sharedPreferences.setString("refresh", refreshToken);
      lastToken = DateTime.now();
      return;
    } else {
      throw Exception("Error Code: ${response.statusCode}");
    }
  }
}
