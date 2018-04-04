import 'dart:async';
import 'package:flutter/material.dart';
import '../domains/api_client.dart';
import '../domains/user.dart';
import 'my_page.dart';
import 'login_page.dart';

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

  void _displayLoginPage() {
    _updateComponent(new LoginPage(onLoggedIn: _handleLoggedIn));
  }

  void _displayMyPage(User user) {
    _updateComponent(new MyPage(user: user));
  }

  Future<void> _setupComponent() async {
    var token = await APIClient.getSavedToken();
    if (token == null) {
      _displayLoginPage();
    } else {
      var user = await User.getCurrentUser();
      _displayMyPage(user);
    }
  }

  @override
  void initState() {
    super.initState();
    APIClient.onFailAuth(() { _displayLoginPage(); });
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
