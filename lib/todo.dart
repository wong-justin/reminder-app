import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:math';

import 'timing.dart';
import 'notifications.dart';


class TodoWidget extends StatefulWidget {
    final TodoData todoData;
    
    TodoWidget({this.todoData, Key key}) : super(key: key);
    
     @override
    _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
        
    TimerText _timerText;
    
    @override
    void initState() {
        _timerText = new TimerText(
            expiration: widget.todoData.expiration,
        );    
    }
    
    @override
    Widget build(BuildContext context) {
        return Container(
            child: ListTile(
                title: Text(
                    widget.todoData.name,
                    style: Theme.of(context).textTheme.body1
                ),
                subtitle: widget.todoData.description == null ?
                    null: 
                    Text(
                        widget.todoData.description,
                    ),
                trailing: _timerText,
                onTap: () {
                    print(widget.todoData);
//                    setState(() {
//                        
//                    });
                    print(_timerText.expiration);
                },
            ),
            color: Colors.grey[800],
        );
    }
}

class TodoData {
        
    String name;
    String description;
    DateTime expiration; 
    
    // Ideally repeatInterval is replaced by custom repeat rules [class],
    //  named something like RecurringRule,
    //  supporting eg first and last Monday of month;
    //  would be used with custom recurring notification implementation.
    // For now, settling for the very limited RepeatInterval enum
    //  provided by local_notifications_plugin:
    //  [EveryMinute], Hourly, Daily, Weekly
    RepeatInterval repeatInterval = null;
//    bool isRecurring;
    
    final DateTime _created = DateTime.now();
    int id;// = created.hash();
    
    TodoData({this.name, 
              this.description, 
              this.expiration,
              this.repeatInterval,}) {
        id = _created.hashCode;
        
        if (repeatInterval == null) {
            scheduleNotification(id,
                                 name,
                                 description,
                                 expiration);          
        } else {
            scheduleRecurringNotification(id,
                                          name,
                                          description,
                                          repeatInterval,
                                          expiration);
        }
    }
    
    // should be called when someone wants 
    // to delete this TodoData
    void dispose() async {
        cancelNotification(this.id);
    }    
    
    @override
    String toString() {
        return [
            'name: ' + name,
            'description: ' + description.toString(),
            'created: ' + _created.toString(),
            'expiration: ' + expiration.toString(),
            'repeatInterval: ' + repeatInterval.toString(),
        ].join('\n');
    }
}

List<TodoData> generateSampleTodos(int n) {
    return generateWordPairs().take(n).toList().map(
        (WordPair pair) {
            
            int randMinutes = Random().nextInt(180);
            return TodoData(
                name: pair.asPascalCase,
                description: 'sample description',
                expiration: DateTime.now().add(
                    Duration(minutes: randMinutes,)),
            );
        }
    ).toList();
}