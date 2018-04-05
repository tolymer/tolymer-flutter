import 'dart:async';
import 'package:flutter/material.dart';
import '../domains/group.dart';
import '../domains/user.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class NewEventPage extends StatefulWidget {
  NewEventPage({ Key key, this.group }) : super(key: key);

  final Group group;

  @override
  _NewEventPageState createState() => new _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();

  DateTime _date = new DateTime.now();
  Map<int, bool> _memberChecked = {};
  List<User> _members = [];

  void _setup() async {
    var members = await widget.group.getMembers();
    setState(() {
      _members = members;
      members.forEach((user) {
        _memberChecked[user.id] = true;
      });
    });
  }

  void _handleSave() async {
    var event = await widget.group.createEvent({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': '${_date.year}-${_date.month}-${_date.day}'
    });

    List<int> userIds = [];
    _memberChecked.forEach((id, checked) {
      if (checked) {
        userIds.add(id);
      }
    });
    await event.addMembers(userIds);
    Navigator.pop(context, DismissDialogAction.save);
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Event'),
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
        children: <Widget>[
          new TextField(
            controller: _titleController,
            decoration: new InputDecoration(hintText: 'Event Title'),
          ),
          new TextField(
            controller: _descriptionController,
            decoration: new InputDecoration(hintText: 'Event Description'),
          ),
          new _DatePicker(
            selectedDate: _date,
            selectDate: (DateTime date) {
              _date = date;
            }
          ),
        ]..addAll(_members.map((user) {
          return new ListTile(
            leading: new Checkbox(value: _memberChecked[user.id], onChanged: (v) => setState(() { _memberChecked[user.id] = v; })),
            title: new Text(user.name),
          );
        })),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2100)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new _InputDropdown(
      labelText: 'Date',
      valueText: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
      valueStyle: valueStyle,
      onPressed: () { _selectDate(context); },
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}
