import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'dart:async';

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

void initNotificationPlugin() async {
    
    WidgetsFlutterBinding.ensureInitialized();
    
    final BehaviorSubject<String> selectNotificationSubject = 
        BehaviorSubject<String>();
    
    NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    
    var initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');//app_icon');
    var initSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
    );
        
    var initSettings = InitializationSettings(
        initSettingsAndroid,
        initSettingsIOS
    );
        
    await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onSelectNotification: (String payload) async {
            if (payload != null) {
                debugPrint('notification payload: ' + payload);
            }
            selectNotificationSubject.add(payload);
            
            // listener for when user opens notification:
//            selectNotificationSubject.stream.listen((String payload) async {
//                // do something with payload
//            });
        }
    );
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
            home: RandomWords(),
        );
    }
}

class RandomWords extends StatefulWidget {
    @override
    _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
            
    final _list1 = initSampleTodos();
//    final _list2 = initSampleTodos();
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
                               onPressed: _pushFavorited),
                ]
            ),
            body: ListView(
                children: [
                    _buildHeader('urgent'),
                    Sublist(
                        list: _list1,
                    ),
//                    _buildHeader('soon'),
//                    Sublist(
//                        list: _list2,
//                    ),
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
    
    Widget _buildHeader(String titleText) {
        
        return Padding(
            padding: EdgeInsets.all(12),
            child: Text(
                titleText.toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[200].withOpacity(0.3),
                )
            ),
        );
    }
    
    void _pushTodoCreationRoute() {
        var result = Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyFormPage()),
        );
    }
    
    void _pushFavorited() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    
                    final tiles = (_list1).map(// + _list2 + _list3).map(
                        (TodoData li) {
                            return ListTile(
                                title: _liText(li.name),
                            );
                        }
                    );
                    
                    final divided = ListTile.divideTiles(
                        context: context,
                        tiles: tiles,
                    ).toList();
                    
                    return Scaffold(
                        appBar: AppBar(
                            title: Text('Settings'),
                        ),
                        body: ListView(children: divided),
                    );
                }
            )
        );
    }
    
    Widget _liText(String title) {
        return Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
            ),
        );
    }
    
    void _searchFunction() {
        
    }
}

class Sublist extends StatefulWidget {
    
    final List<TodoData> list;
    
    Sublist({this.list,});
    
     @override
    _SublistState createState() => _SublistState();
} 

class _SublistState extends State<Sublist> {
        
    @override
    Widget build(BuildContext context) {
                
        return Column(
            children: ListTile.divideTiles(
                context: context,
                tiles: widget.list.map((TodoData td) {
                    return TodoWidget(td);
                }),
                color: Theme.of(context).scaffoldBackgroundColor,
            ).toList(),
        );
    }    
}
