import 'dart:async';
import 'package:flutter/material.dart';
import '../domains/group.dart';

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
  DateTime _date = new DateTime.now();
  List<bool> _memberChecked = [true, true, true, true];

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
              Navigator.pop(context, DismissDialogAction.save);
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
          new _DatePicker(
            selectedDate: _date,
            selectDate: (DateTime date) {
              _date = date;
            }
          ),
          new ListTile(
            leading: new Checkbox(value: _memberChecked[0], onChanged: (v) => _memberChecked[0] = v),
            title: new Text('hokaccha'),
          ),
          new ListTile(
            leading: new Checkbox(value: _memberChecked[1], onChanged: (v) => _memberChecked[1] = v),
            title: new Text('1000ch'),
          ),
          new ListTile(
            leading: new Checkbox(value: _memberChecked[2], onChanged: (v) => _memberChecked[2] = v),
            title: new Text('hilok'),
          ),
          new ListTile(
            leading: new Checkbox(value: _memberChecked[3], onChanged: (v) => _memberChecked[3] = v),
            title: new Text('tan_yuki'),
          ),
        ],
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
