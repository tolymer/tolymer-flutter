import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tolymer',
      theme: new ThemeData(primarySwatch: Colors.green),
      home: new LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  _handlePressed() async {
    var token = await login(_nameController.text, _passwordController.text);
    var user = await getCurrentUser(token);

    showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Logged in'),
        content: new Text('id: ${user["id"]}, name: ${user["name"]}'),
      ),
    );
  }

  Future<String> login(String name, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedToken = prefs.getString('token');
    if (savedToken != null) {
      return savedToken;
    }
    var url = 'http://localhost:3000/user_token';
    var body = { "auth": { "name": name, "password": password } };
    var headers = { 'content-type': 'application/json; charset=utf-8' };
    var response = await http.post(url, body: json.encode(body), headers: headers);
    var token = json.decode(response.body)['jwt'];
    prefs.setString('token', token);
    return token;
  }

  Future getCurrentUser(String token) async {
    var url = 'http://localhost:3000/current_user';
    var headers = { 'Authorization': 'Bearea $token' };
    var response = await http.get(url, headers: headers);
    var user = json.decode(response.body);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title)),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: _nameController,
              decoration: new InputDecoration(hintText: 'UserName'),
            ),
            new TextField(
              controller: _passwordController,
              decoration: new InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            new RaisedButton(
              onPressed: _handlePressed,
              child: new Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
