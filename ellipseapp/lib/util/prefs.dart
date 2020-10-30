import 'package:shared_preferences/shared_preferences.dart';

String prefId = "",
    prefName = "",
    prefEmail = "",
    prefToken = "",
    prefCollegeId = "",
    prefCollegeName = "",
    prefFirebaseMessagingToken = "";
int prefNotificationsCount = 0;
bool prefLoggedIn;
loadPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefLoggedIn = prefs.getBool("loggedIn");
  prefId = prefs.getString("id");
  prefName = prefs.getString("name");
  prefEmail = prefs.getString("email");
  prefToken = prefs.getString("token");
  prefCollegeId = prefs.getString("collegeId");
  prefCollegeName = prefs.getString("collegeName");
  prefFirebaseMessagingToken = prefs.getString("firebaseMessagingToken");
}

resetPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("loggedIn", false);
  prefs.setString("id", "");
  prefs.setString("name", "");
  prefs.setString("email", "");
  prefs.setString("token", "");
  prefs.setString("collegeId", "");
  prefs.setString("collegeName", "");
  prefs.setString("firebaseMessagingToken", "");
}

loadNotificationsCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefNotificationsCount = prefs.getInt("notificationsCount");
}
