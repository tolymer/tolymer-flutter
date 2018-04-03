import 'dart:async';
import 'package:flutter/material.dart';
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
