import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'dart:async';

import 'notifications.dart';
import 'todo.dart';
import 'create.dart';

// obj passed whenever handling notification actions
//  like scheduling, initialization, permissions, etc
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
        FlutterLocalNotificationsPlugin();

void main() async {
    await initNotificationPlugin();
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
                
        return MaterialApp(
            title: 'Todo List',
            theme: ThemeData(
                primaryColor: Colors.grey[600],
                scaffoldBackgroundColor: Colors.grey[900],
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.grey[100],
                ),
                textTheme: TextTheme(
                    body1: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                    ),
                ),
            ),
            home: HomePage(),
        );
    }
}

class HomePage extends StatefulWidget {

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
            
    List<TodoData> _urgentList = initSampleTodos();
    final _soonList = initSampleTodos();
//    final _list3 = initSampleTodos();
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Todo List'),
                actions: [
                    IconButton(icon: Icon(Icons.search),
                               onPressed: _searchFunction),
                    IconButton(icon: Icon(Icons.more_vert),
                               onPressed: _pushSettingsRoute),
                ]
            ),
            body: ListView(
                children: [
                    Sublist(
                        title: 'urgent',
                        list: _urgentList,
                    ),
                    Sublist(
                        title: 'soon',
                        list: _soonList,
                    ),
//                    _buildHeader('sometime'),
//                    Sublist(
//                        list: _list3,
//                    ),
                ],
                padding: EdgeInsets.only(bottom: 56),   // 40 for mini
            ),                
            floatingActionButton: InkWell(
                splashColor: Colors.red,
                customBorder: new CircleBorder(),
                onLongPress: () {},
                child: FloatingActionButton(
                    onPressed: _pushTodoCreationRoute,
                    tooltip: 'Add Todo',
                    child: Icon(Icons.add),
                ),
            ),
        );
    }
    
    void _pushTodoCreationRoute() async {
        var newTodo = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyFormPage()),
        );
        
        if (newTodo == null) {
            return;
        }
        
        // do something with new TodoData
        int compareDates(curr, other) {
            if (curr.expiration.isBefore(other.expiration)) {
                return -1;
            }
            else {
                return 1;
            }
        }
        DateTime thisDate = newTodo.expiration;
        if (thisDate.isBefore(DateTime.now())) {
            // insert into ordered urgent list            
            insertInto(_urgentList, 
                       newTodo, 
                       compareDates);
            setState(() {});
        }
        else {
            insertInto(_soonList,
                       newTodo,
                       compareDates);
            setState(() {});
        }
        
        
        // method 3, trying to debug timertext taking on adjacent value from list
//        setState(() {
//            _urgentList.insert(3, new TodoData(
//                name: 'filler',
//                expiration: DateTime.now(),
//            ));
//            _urgentList.insert(4, newTodo);
//        });
        
        // method 4, copying into new list
//        DateTime thisDate = newTodo.expiration;
//        List<TodoData> newList = [];
//        int i = 0;
//        for (i; i < _urgentList.length; i++) {
//            TodoData otherTodo = _urgentList[i];
//            if (thisDate.isBefore(otherTodo.expiration)) {
//                break;
//            } else {
//                newList.add(otherTodo);
//            }
//        }
//        newList.add(newTodo);
//        i++;
//        while (i < _urgentList.length) {
//            newList.add(_urgentList[i]);
//            i++;
//        }
//        _urgentList = newList;
//        setState(() {});
        

    }
    
    void _pushSettingsRoute() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    
                    return Scaffold(
                        appBar: AppBar(
                            title: Text('Settings'),
                        ),
                        body: Text('settings here'),
                    );
                }
            )
        );
    }
    
    void _searchFunction() {
        
    }
}

class Sublist extends StatefulWidget {
    
    final String title;
    final List<TodoData> list;
    
    Sublist({this.list, this.title,});
    
     @override
    _SublistState createState() => _SublistState();
} 

class _SublistState extends State<Sublist> {
        
    @override
    Widget build(BuildContext context) {
        
        List<Widget> items = ListTile.divideTiles(
            context: context,
            tiles: widget.list.map((TodoData td) {
                return TodoWidget(
                    key: UniqueKey(),
                    todoData: td,
                );
            }),
            color: Theme.of(context).scaffoldBackgroundColor,
        ).toList();
        
        items.insert(0, _buildHeader());        
        
        return Column(
            children: items,
        );
    }    
    
    Widget _buildHeader() {
        
        return Padding(
            padding: EdgeInsets.all(12),
            child: Row(
                children: <Widget>[
                    Text(
                        widget.title.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey[200].withOpacity(0.3),
                        )
                    ),
                    Spacer(),
                ],
            ),
        );            
    }    
}

void insertInto(List list, newItem, compareKey) {
    int i = 0;
    for (i; i < list.length; i++) {
        var otherItem = list[i];
        int comparison = compareKey(newItem, otherItem);
        if (comparison < 0) {
            break;
        }
    }
    list.insert(i, newItem);
}