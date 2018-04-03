import 'package:flutter/material.dart';
import '../domains/user.dart';
import 'group_page.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Group> _groups = [];

  _setup() async {
    var groups = await widget.user.getGroups();
    setState(() => _groups = groups);
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles = _groups.map((group) {
      return new ListTile(
        leading: new Icon(Icons.group),
        title: new Text(group.name),
        subtitle: new Text(group.description),
        onTap: () {
          var route = new MaterialPageRoute(builder: (context) => new GroupPage(group: group));
          Navigator.of(context).push(route);
        },
      );
    });
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.user.name)),
      body: new ListView(children: listTiles.toList()),
    );
  }
}
