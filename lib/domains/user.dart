import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class User {
  User({ this.id, this.name });

  final int id;
  final String name;

  static final String endpoint = 'http://localhost:3000';

  static _get(String path, { auth: true }) async {
    var url = '$endpoint$path';
    var headers = {};
    if (auth) {
      var token = await getSavedToken();
      headers['Authorization'] = 'Bearea $token';
    }
    var response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  static _post(String path, body, { auth: true }) async {
    var url = '$endpoint$path';
    var headers = { 'content-type': 'application/json; charset=utf-8' };
    if (auth) {
      var token = await getSavedToken();
      headers['Authorization'] = 'Bearea $token';
    }
    var response = await http.post(url, body: json.encode(body), headers: headers);
    return json.decode(response.body);
  }

  static Future<String> getSavedToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> login(String name, String password) async {
    var body = { "auth": { "name": name, "password": password } };
    var response = await _post('/user_token', body);
    var token = response['jwt'];
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return true;
  }

  static Future<User> getCurrentUser() async {
    var user = await _get('/current_user');
    return new User(id: user['id'], name: user['name']);
  }
}
