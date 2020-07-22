import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'timing.dart';


class TodoWidget extends StatefulWidget {
    final TodoData todoData;
    
    TodoWidget({this.todoData,});
    
     @override
    _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
    
    bool _toggle = false;
    
    @override
    Widget build(BuildContext context) {
        return Container(
            child: ListTile(
//                title: _liText(widget.todoData.formattedExpiration()),
                title: TimerText(
                    expiration: widget.todoData.expiration
                ),
                trailing: Icon(
                    _toggle ? Icons.favorite : Icons.favorite_border,
                    color: _toggle ? Colors.red : null,
                ),
                onTap: () {
                    _toggle = ! _toggle;
                    setState(() {
                        
                    });
                }
            ),
            color: Colors.grey[800],
        );
    }
    
    Widget _liText(String text) {
        return Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
            ),
        );
    }
}

class TodoData {
        
    String name;
    DateTime expiration = DateTime.now().add(
        new Duration(minutes: 3));
    
    TodoData({this.name,});    
}

List<TodoData> initSampleTodos() {
    return generateWordPairs().take(4).toList().map(
        (WordPair pair) {
            return TodoData(
                name: pair.asPascalCase,
            );
        }
    ).toList();
}