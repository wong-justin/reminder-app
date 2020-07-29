import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

import 'todo.dart';

class MyFormPage extends StatefulWidget {
    
    @override
    _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
    
    DateField _dateField;
    TimeField _timeField;
    NameField _nameField;
    DescriptionField _descriptionField;
    RecurringField _recurringField;
    
    @override
    void initState() {
        _dateField = DateField();
        _timeField = TimeField();
        _nameField = NameField();
        _descriptionField = DescriptionField();
        _recurringField = RecurringField();
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
                    _descriptionField,
                    Row(
                        children: <Widget>[
                            _dateField,
                            Spacer(),
                            _timeField,
                        ],
                    ),
                    _recurringField,
                    _buildSubmitBtn(),                   
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
            _dateField.date.year,
            _dateField.date.month,
            _dateField.date.day,
            _timeField.time.hour,
            _timeField.time.minute,
        );
        print(expiration);
        
        TodoData todoData = TodoData(
            name: _nameField.name,
            description: _descriptionField.description,
            expiration: expiration,
            repeatInterval: _recurringField.repeatInterval,
        );
        print(todoData);
        
        // return to previous screen (the one that asked for new TodoData)
        // and give result data in TodoData obj.
        Navigator.pop(context, todoData);
    }
    
    Widget _buildSubmitBtn() {
        return Column(
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
        );
    }
}

class DateField extends StatefulWidget {
    DateTime date = DateTime.now();
    
    DateTime getValue() {
        return date;
    }
    
    @override
    _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
    
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

class TimeField extends StatefulWidget {
    TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());
    
    @override
    _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
    
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

class DescriptionField extends StatefulWidget {
    String description;
    
    @override
    _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {

    @override
    Widget build(BuildContext context) {
        TextStyle textStyle = Theme.of(context).textTheme.body1;

        return TextField(
            onChanged: (String newDescription) {
                widget.description = newDescription;
            },
            decoration: InputDecoration(
                hintText: '(Optional) description',
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

class RecurringField extends StatefulWidget {
    RepeatInterval repeatInterval = null;
    
    @override
    _RecurringFieldState createState() => _RecurringFieldState();
}

class _RecurringFieldState extends State<RecurringField> {
    
    @override
    Widget build(BuildContext context) {
        
        return _buildChooser();
//        return ListTile(
//            leading: _buildChooser(),
//            title: Text(
//                widget.repeatInterval == null ?
//                    'Not recurring' :
//                    describeEnum(widget.repeatInterval),
//            ),
//            
//        );
    }
    
    Widget _buildChooser() {
        
        ListTile nullChoice = ListTile(
            title: Text('Not recurring'),
            leading: Radio(
                value: null,
                groupValue: widget.repeatInterval,
                onChanged: (value) {
                    widget.repeatInterval = value;
                    setState(() {});
                }
            ),
        );
        
        List<ListTile> otherChoices = [
            RepeatInterval.Daily,
            RepeatInterval.Weekly,
        ].map((intervalType) {
            return ListTile(
                title: Text(describeEnum(intervalType)),
                leading: Radio(
                    value: intervalType,
                    groupValue: widget.repeatInterval,
                    onChanged: (value) {
                        widget.repeatInterval = value;
                        setState(() {});
                    }
                ),
            );
        }).toList();
        
        ListTile customChoice = ListTile(
            title: Text('Custom...'),
            leading: Radio(
                value: -1,
                groupValue: widget.repeatInterval,
                onChanged: null,
//                onChanged: (value) {
//                    // show advanced custom repeat interval choosing widget
//                    //  (whether dialog or route, etc)
//                    
//                }
            )
        );
        
        List<Widget> choices = [nullChoice, ...otherChoices, customChoice];
        
        return Column(
            children: choices,
        );
        
//        return PopupMenuButton<RepeatInterval>(
//            onSelected: (RepeatInterval selected) {
//                print(selected);
//                
//                widget.repeatInterval = selected;
//                setState(() {});
//            },
//            itemBuilder: (BuildContext context) {
//                return [
//                    null,
//                    RepeatInterval.Hourly,
//                    RepeatInterval.Daily,
//                    RepeatInterval.Weekly,
//                ].map((repeatIntervalType) {
//                    return PopupMenuItem<RepeatInterval>(
//                        value: repeatIntervalType,
//                        child: Text(
//                            repeatIntervalType == null ?
//                                'Not recurring' :
//                                describeEnum(repeatIntervalType),
//                        ),
//                    );
//                }).toList();
//            }
//        );
    }
    
    Widget _buildCheckbox () {
        return Checkbox(
            value: widget.repeatInterval != null,
            onChanged: (bool gotChecked) {
                if (gotChecked) {
                    // choose RepeatInterval
                    widget.repeatInterval = RepeatInterval.Daily;
                } else {
                    // unchoose RepeatInterval
                    widget.repeatInterval = null;
                }
                setState(() {});
            }
        );
    }
}