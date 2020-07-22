import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';

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
            
    final _list1 = initSampleTodoItems();
    final _list2 = initSampleTodoItems();
    final _list3 = initSampleTodoItems();
    
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
                        (TodoItem li) {
                            return ListTile(
                                title: _liText(li.text),
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
    
    final List<TodoItem> list;
    
    Sublist({this.list,});
    
     @override
    _SublistState createState() => _SublistState();
} 

class _SublistState extends State<Sublist> {
    
    final _favoritedItems = Set<TodoItem>();
    
    @override
    Widget build(BuildContext context) {
        return Column(
            children: widget.list.map(
                (TodoItem li) {
                    return Padding(
                        padding: EdgeInsets.all(2),
                        child: _buildRow(li),
                    );
                }
            ).toList()
        );
    }
    
    Widget _buildRow(TodoItem li) {
        final alreadySaved = _favoritedItems.contains(li);
        
        return Container(
            child: ListTile(
                title: _liText(li.formattedExpiration()),
                trailing: Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.blue : null,
                ),
                onTap: () {
                    setState(() {
                        if (alreadySaved) {
                            _favoritedItems.remove(li);
                        } else {
                            _favoritedItems.add(li);
                        }
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

class TodoItem {
    
    static DateFormat dateFormatter = DateFormat('kk:mm:ss \n EEE d MMM');
    
    String text;
    DateTime expiration = DateTime.now();
    
    TodoItem({this.text,});
    
    String formattedExpiration() {
        return dateFormatter.format(expiration);
    }
}

List<TodoItem> initSampleTodoItems() {
    return generateWordPairs().take(4).toList().map(
        (WordPair pair) {
            return TodoItem(
                text: pair.asPascalCase,
            );
        }
    ).toList();
}