import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(new App());

class App extends StatefulWidget {
  App({ Key key }) : super(key: key);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  Widget _currentComponent = new Container();

  void _handleLoggedIn(User user) {
    setState(() => _currentComponent = new MyPage(user: user));
  }

  void _updateComponent(component) {
    setState(() => _currentComponent = component);
  }

  Future<void> _setupComponent() async {
    var token = await User.getSavedToken();
    if (token == null) {
      _updateComponent(new LoginPage(onLoggedIn: _handleLoggedIn));
    } else {
      var user = await User.getCurrentUser();
      _updateComponent(new MyPage(user: user));
    }
  }

  @override
  void initState() {
    super.initState();
    this._setupComponent();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tolymer',
      theme: new ThemeData(primarySwatch: Colors.green),
      home: _currentComponent,
    );
  }
}

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

typedef void LoggedInCallback(User user);

class LoginPage extends StatefulWidget {
  LoginPage({ Key key, this.onLoggedIn }) : super(key: key);

  final LoggedInCallback onLoggedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  _handlePressed() async {
    var loggedIn = await User.login(_nameController.text, _passwordController.text);
    if (!loggedIn) {
      print('Login faild');
    }
    var user = await User.getCurrentUser();
    widget.onLoggedIn(user);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Login')),
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

class MyPage extends StatefulWidget {
  MyPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.user.name)),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text('Hello ${widget.user.name}'),
          ],
        ),
      ),
    );
  }
}
