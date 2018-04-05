import 'dart:async';
import 'package:flutter/material.dart';
import '../domains/group.dart';
import '../domains/user.dart';
import '../domains/event.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class NewGamePage extends StatefulWidget {
  NewGamePage({ Key key, this.event, this.members }) : super(key: key);

  final Event event;
  final List<User> members;

  @override
  _NewGamePageState createState() => new _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  Map<int, TextEditingController> _controllers = {};

  _handleSave() async {
    var scores = [];
    _controllers.forEach((userId, controller) {
      scores.add({ 'user_id': userId, 'point': int.parse(controller.text) });
    });
    await widget.event.createGame(scores);
    Navigator.pop(context, DismissDialogAction.save);
  }

  _items() {
    return widget.members.map((user) {
      return new Container(
        padding: const EdgeInsets.only(top: 40.0, left: 50.0, right: 50.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(user.name),
            new TextField(
              controller: _controllers[user.id],
              decoration: new InputDecoration(hintText: 'Score'),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    widget.members.forEach((user) {
      _controllers[user.id] = new TextEditingController();
    });
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Game Result'),
        actions: <Widget> [
          new FlatButton(
            child: new Text('SAVE', style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              _handleSave();
            }
          )
        ]
      ),
      body: new Column(
        children: _items(),
      )
    );
  }
}
