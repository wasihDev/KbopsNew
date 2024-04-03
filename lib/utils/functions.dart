import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<Map<dynamic, dynamic>> fetchDate() async {
  final res = await http.get(Uri.parse("https://kbops.online/date.php"));
  final date = jsonDecode(res.body);
  return date;
}
