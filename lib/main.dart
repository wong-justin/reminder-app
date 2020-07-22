import 'package:flutter/material.dart';
import 'todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
                
        return MaterialApp(
            title: 'Startup Name Generator',
            theme: ThemeData(
                primaryColor: Colors.grey[600],
                scaffoldBackgroundColor: Colors.grey[900],
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.grey[100],
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
    final _list2 = initSampleTodos();
    final _list3 = initSampleTodos();
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Startup Name Generator'),
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
                    _buildHeader('soon'),
                    Sublist(
                        list: _list2,
                    ),
                    _buildHeader('sometime'),
                    Sublist(
                        list: _list3,
                    ),
                ],
                padding: EdgeInsets.only(bottom: 56),   // 40 for mini
            ),                
            floatingActionButton: FloatingActionButton(
                onPressed: () => {},
                tooltip: 'Add',
                child: Icon(Icons.add),
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
    
    void _pushFavorited() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    
                    final tiles = (_list1 + _list2 + _list3).map(
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
                            title: Text('Favorited Suggestions'),
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
    
    final _favoritedItems = Set<TodoData>();
    
    @override
    Widget build(BuildContext context) {
        return Column(
            children: widget.list.map(
                (TodoData li) {
                    return Padding(
                        padding: EdgeInsets.all(2),
                        child: _buildRow(li),
                    );
                }
            ).toList()
        );
    }
    
    Widget _buildRow(TodoData li) {
        final alreadySaved = _favoritedItems.contains(li);
        
        return TodoWidget(todoData: li);
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
