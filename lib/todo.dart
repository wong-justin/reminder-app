import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'dart:math';

import 'timing.dart';


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
//                title: _liText(widget.todoData.name),
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
    bool isRecurring;
    DateTime expiration;//DateTime.now()
    
    DateTime _created = DateTime.now();
    
    TodoData({this.name, 
              this.description, 
              this.expiration,
              this.isRecurring,});
    
    @override
    String toString() {
        return [
            'name: ' + name,
            'description: ' + description.toString(),
            'created: ' + _created.toString(),
            'expiration: ' + expiration.toString(),
            'isRecurring: ' + isRecurring.toString(),
        ].join('\n');
    }
}

List<TodoData> initSampleTodos() {
    return generateWordPairs().take(3).toList().map(
        (WordPair pair) {
            
            int randMinutes = Random().nextInt(180);
            return TodoData(
                name: pair.asPascalCase,
                expiration: DateTime.now().add(
                    Duration(minutes: randMinutes,)),
            );
        }
    ).toList();
}