import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class User {
  User({ this.id, this.name });

  final int id;
  final String name;

  static Future<String> getSavedToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> login(String name, String password) async {
    var url = 'http://localhost:3000/user_token';
    var body = { "auth": { "name": name, "password": password } };
    var headers = { 'content-type': 'application/json; charset=utf-8' };
    var response = await http.post(url, body: json.encode(body), headers: headers);
    var token = json.decode(response.body)['jwt'];
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return true;
  }

  static Future<User> getCurrentUser() async {
    var token = await getSavedToken();
    var url = 'http://localhost:3000/current_user';
    var headers = { 'Authorization': 'Bearea $token' };
    var response = await http.get(url, headers: headers);
    var user = json.decode(response.body);
    return new User(id: user['id'], name: user['name']);
  }
}
