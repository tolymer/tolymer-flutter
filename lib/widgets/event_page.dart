import 'dart:async';
import 'package:flutter/material.dart';
import 'new_game_page.dart';
import '../domains/game.dart';
import '../domains/event.dart';
import '../domains/user.dart';

class EventPage extends StatefulWidget {
  EventPage({ Key key, this.event }) : super(key: key);

  final Event event;

  @override
  _EventPageState createState() => new _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<User> _members = [];
  List<Game> _games = [];

  _setup() async {
    var members = await widget.event.getMembers();
    var games = await widget.event.getGames();
    setState(() {
      _members = members;
      _games = games;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 2);
    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.event.title),
        bottom: new TabBar(
          controller: _controller,
          tabs: [
            new Tab(text: 'Info'),
            new Tab(text: 'Games'),
          ]
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        children: [_infoTab(), _gamesTab()],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openNewGamePage,
        tooltip: 'New Game',
        child: new Icon(Icons.add),
      ),
    );
  }

  _infoTab() {
    var headingStyle = new TextStyle(fontSize: 16.0, color: Colors.grey);
    var textStyle = new TextStyle(fontSize: 18.0);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: new Text('Description', style: headingStyle),
        ),
        new Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(widget.event.description, style: textStyle),
        ),

        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: new Text('Date', style: headingStyle),
        ),
        new Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(widget.event.date, style: textStyle),
        ),

        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 0.0, left: 20.0, right: 20.0),
          child: new Text('Members', style: headingStyle),
        ),
      ]..addAll(_members.map((user) {
        return new Container(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: new Text(user.name, style: textStyle),
        );
      }).toList()),
    );
  }

  _gamesTab() {
    if (_members.isEmpty) {
      return new Container();
    }

    List<TableRow> rows = [];

    TableRow headRow = new TableRow(
      children: _members.map((user) {
        var text = new Text(user.name);
        var container = new Container(
          child: text,
          padding: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
          color: Colors.grey[200],
        );
        return new TableCell(child: container);
      }).toList(),
    );

    Map<int, int> totalPointByUserId = {};
    _members.forEach((user) {
      totalPointByUserId[user.id] = 0;
    });
    List<TableRow> scoreRows = _games.map((game) {
      var pointByUserId = {};
      game.scores.forEach((score) {
        pointByUserId[score['user_id']] = score['point'];
        totalPointByUserId[score['user_id']] += score['point'];
      });
      var cells = _members.map((user) {
        var text = new Text(pointByUserId[user.id].toString());
        var container = new Container(
          child: text,
          padding: new EdgeInsets.all(10.0),
        );
        return new TableCell(child: container);
      }).toList();
      return new TableRow(children: cells);
    }).toList();

    TableRow totalRow = new TableRow(
      children: _members.map((user) {
        var text = new Text(totalPointByUserId[user.id].toString());
        var container = new Container(
          child: text,
          padding: new EdgeInsets.all(10.0),
          color: Colors.red[100],
        );
        return new TableCell(child: container);
      }).toList(),
    );

    rows.add(headRow);
    rows.addAll(scoreRows);
    rows.add(totalRow);

    return new Table(children: rows);
  }

  Future _handleCreateGame() async {
    var games = await widget.event.getGames();
    setState(() {
      _games = games;
    });
  }

  _openNewGamePage() {
    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
      builder: (BuildContext context) => new NewGamePage(event: widget.event, members: _members, onCreateGame: _handleCreateGame),
      fullscreenDialog: true,
    ));
  }
}
