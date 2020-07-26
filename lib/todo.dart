import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'timing.dart';


class TodoWidget extends StatefulWidget {
    final TodoData todoData;
    
    TodoWidget(this.todoData,);
    
     @override
    _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
        
    @override
    Widget build(BuildContext context) {
        return Container(
            child: ListTile(
                title: Text(
                    widget.todoData.name,
                    style: Theme.of(context).textTheme.body1
                ),
//                title: _liText(widget.todoData.name),
                trailing: TimerText(
                    expiration: widget.todoData.expiration,
                ),
                onTap: () {
//                    setState(() {
//                        
//                    });
                },
            ),
            color: Colors.grey[800],
        );
    }
}

class TodoData {
        
    String name;
    String description;
    DateTime expiration;//DateTime.now()
    DateTime _created = DateTime.now();
    
    TodoData({name, 
              description, 
              expiration,}) {
        debugPrint('expiration: ' + expiration.toString());
        this.name = name;
        this.description = description;
        this.expiration = expiration != null ?
            expiration :
            DateTime.now().add(
                new Duration(minutes: 60, seconds: 15,));
            
    }
}

List<TodoData> initSampleTodos() {
    return generateWordPairs().take(2).toList().map(
        (WordPair pair) {
            return TodoData(
                name: pair.asPascalCase,
            );
        }
    ).toList();
}