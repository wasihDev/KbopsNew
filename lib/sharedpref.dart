import 'package:kbops/utils/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<bool> Data(String name, String email) async {
//   final pref = await SharedPreferences.getInstance();
//   await pref.setString('name', name);
//   await pref.setString('email', email);
//   return pref.commit();
// }
//
// Future<bool>getData()async{
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   await pref.get('name');
//   await pref.get('email');
//   return  getData();
// }

Future<dynamic> setUser(
  var username,
  var email,
  var photo,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("username", username);
  pref.setString("email", email);
  pref.setString("photourl", photo);
  return 1;
}

Future<Map<String, dynamic>> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var username = pref.getString("username");
  var email = pref.getString("email");
  var photo = pref.getString("photourl");
  return {"username": username, "email": email, "photourl": photo};
}

Future<bool> setLogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('login', true);
  return true;
}

Future<bool> checkLogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getBool('login') ?? false;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove('login');
  return true;
}

Future<bool> setReward(date) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('reward', date);
  return true;
}

Future<String> checkReward() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('reward') ?? "";
}

Future<bool> DontShowToday(date) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('popup', date);
  return true;
}

Future<String> getPopUp() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("popup") ?? "";
}
