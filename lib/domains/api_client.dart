import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

typedef void onFailAuthCallback();

class APIClient {
  static String endpoint;
  static onFailAuthCallback _onFailAuthCallback;

  static get(String path, { auth: true }) async {
    var url = '$endpoint$path';
    var headers = {};
    if (auth) {
      var token = await getSavedToken();
      headers['Authorization'] = 'Bearea $token';
    }
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 401) {
      await _authFailed();
      throw new Exception('Auth Failed');
    } else if (response.statusCode >= 400) {
      throw new Exception('[GET $url] ${response.statusCode}, ${response.body}');
    }
    return json.decode(response.body);
  }

  static post(String path, body, { auth: true }) async {
    var url = '$endpoint$path';
    var headers = { 'content-type': 'application/json; charset=utf-8' };
    if (auth) {
      var token = await getSavedToken();
      headers['Authorization'] = 'Bearea $token';
    }
    var response = await http.post(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 401) {
      await _authFailed();
      throw new Exception('Auth Failed');
    } else if (response.statusCode >= 400) {
      throw new Exception('[POST $url] ${response.statusCode}, ${response.body}');
    }
    return json.decode(response.body);
  }

  static Future<String> getSavedToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> login(String name, String password) async {
    var body = { "auth": { "name": name, "password": password } };
    var response = await APIClient.post('/user_token', body);
    var token = response['jwt'];
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return true;
  }

  static onFailAuth(onFailAuthCallback callback) {
    _onFailAuthCallback = callback;
  }

  static _authFailed() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _onFailAuthCallback();
  }
}
