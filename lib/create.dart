import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'todo.dart';

class MyFormPage extends StatefulWidget {
    
    @override
    _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
    
    DatePicker _datePicker;
    TimePicker _timePicker;
    NameField _nameField;
    
    @override
    void initState() {
        _datePicker = DatePicker();
        _timePicker = TimePicker();
        _nameField = NameField();
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold (
            appBar: AppBar(
                title: Text('New Todo'),
            ),
            body: ListView(
                children: <Widget>[
                    _nameField,
                    Row(
                        children: <Widget>[
                            _datePicker,
                            Spacer(),
                            _timePicker,
                        ]
                    ),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[RaisedButton(
                            onPressed: _submitData,
                            child: Text(
                                'SUBMIT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                )
                            ),
                        )],
                    ),                    
                ].map((Widget w) {
                    return Container(
                        padding: EdgeInsets.only(
                            left: 20,
                            top: 10,
                            right: 20,
                            bottom: 10,
                        ),
                        child: w,
                    );
                }).toList(),
            )
        );
    }
    
    void _submitData () {
        
        DateTime expiration = new DateTime(
            _datePicker.date.year,
            _datePicker.date.month,
            _datePicker.date.day,
            _timePicker.time.hour,
            _timePicker.time.minute,
        );
        print(expiration);
        
        TodoData todoData = TodoData(
            name: _nameField.name,
            expiration: expiration,
        );
        print(todoData);
        
        // return to previous screen (the one that asked for new TodoData)
        // and give result data in TodoData obj.
        Navigator.pop(context, todoData);
    }
}

class DatePicker extends StatefulWidget {
    DateTime date = DateTime.now();
    
    DateTime getValue() {
        return date;
    }
    
    @override
    _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
    
    @override
    Widget build(BuildContext context) {
        return FlatButton(
            onPressed: () {return _pick(context);},
            child: Text(
                DateFormat('MMMM d, yyyy').format(widget.date),
                style: Theme.of(context).textTheme.body1,
            ),
        );
    }
    
    void _pick(BuildContext context) async {
        DateTime newDate = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 10),
            initialDate: widget.date,
        );

        if (newDate != null) {
            setState(() {
                widget.date = newDate;
            });
        }
    }
}

class TimePicker extends StatefulWidget {
    TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());
    
    @override
    _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
    
    @override
    Widget build(BuildContext context) {
        return FlatButton(
            onPressed: _pick,
            child: Text(
                widget.time.format(context),
                style: Theme.of(context).textTheme.body1,
            ),
        );
    }
    
    void _pick() async {
        TimeOfDay newTime = await showTimePicker(
            context: context,
            initialTime: widget.time,
        );
            
        if (newTime != null) {
            setState(() {
                widget.time = newTime; 
            });
        }
    }
}

class NameField extends StatefulWidget {
    String name;
    
    @override
    _NameFieldState createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {

    @override
    Widget build(BuildContext context) {
        TextStyle textStyle = Theme.of(context).textTheme.body1;

        return TextField(
            onChanged: (String newName) {
                widget.name = newName;
            },
            decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                    inherit: true,
                    color: textStyle.color.withOpacity(0.25),
                    fontWeight: FontWeight.w300,
                ),
            ),
            style: textStyle,
        );
    }
    
    
}