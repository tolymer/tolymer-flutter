import 'package:flutter/material.dart';
import '../domains/user.dart';

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
