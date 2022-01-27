import 'package:untitledcomics/globals/globals.dart';
import 'globals/user_choice.dart';

void set() {
  sharedPreferences.setBool("set", true);
  sharedPreferences.setString("lang", "EN");
  sharedPreferences.setBool("incognitoMode", false);
  sharedPreferences.setBool("dataSaver", false);
  sharedPreferences.setBool("login", false);
  sharedPreferences.setString("username", "");
  sharedPreferences.setString("token", "");
  sharedPreferences.setString("refresh", "");
  sharedPreferences.setStringList("searchHistory", []);
  sharedPreferences.setStringList("openHistory", []);
}

void get() {
  openHistory = sharedPreferences.getStringList("openHistory")!.toSet();
  searchHistory = sharedPreferences.getStringList("searchHistory")!.toSet();
  incognitoMode = sharedPreferences.getBool("incognitoMode")!;
  login = sharedPreferences.getBool("login")!;
  dataSaver = sharedPreferences.getBool("dataSaver")!;
  if (login) {
    usr = User(
      sharedPreferences.getString("username")!,
      sharedPreferences.getString("session")!,
      sharedPreferences.getString("refresh")!,
      DateTime.now().subtract(const Duration(minutes: 10)),
    );
  }
}
