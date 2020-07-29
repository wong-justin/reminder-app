import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'dart:async';

import 'notifications.dart';
import 'todo.dart';
import 'create.dart';

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
            
    List<TodoData> _urgentList;
    List<TodoData> _soonList;
//    final _list3 = initSampleTodos();
    
    @override
    void initState() {
        _sortTodos(generateSampleTodos(6));
    }
    
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
                padding: EdgeInsets.only(bottom: 88),   // 56 normal, 40 for mini
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
    
    void _sortTodos(List<TodoData> allTodos,) {
        // separate into expired (urgent) and time remaining (soon)
        //  and assign to private vars in state
        allTodos.sort((a, b) => compareDates(a, b));
        int i = 0;
        DateTime now = DateTime.now();
        while (i < allTodos.length) {
            if (allTodos[i].expiration.isBefore(now)) {
                i++;
            } else {
                break;
            }
        }
        print(i);
        
        _urgentList = allTodos.sublist(0, i);
        _soonList = allTodos.sublist(i, allTodos.length);
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
        return Column(
            children: [_buildHeader(), ..._buildListChildren()],
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
    
    List<Widget> _buildListChildren() {
        if (widget.list == null ||
            widget.list.length == 0) {
            return <Widget>[];
        }
        return ListTile.divideTiles(
            context: context,
            tiles: widget.list.map((TodoData td) {
                return TodoWidget(
                    key: UniqueKey(),
                    todoData: td,
                );
            }),
            color: Theme.of(context).scaffoldBackgroundColor,
        ).toList();
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

int compareDates(TodoData curr, TodoData other) {
    if (curr.expiration.isBefore(other.expiration)) {
        return -1;
    }
    else {
        return 1;
    }
}