///projenin ismi moor_deneme olsa da aslinda burada
///flutterda jaguar kutuphanesi ile sqflite
///orm islemlerini gerceklestirdim. (one to many)
///18-05-2020 Cem Ergin.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:moor_deneme/models/post/post.dart';
import 'package:moor_deneme/pages/add_page.dart';
import 'package:moor_deneme/pages/edit_page.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'models/item/item.dart';

/// The adapter
SqfliteAdapter _adapter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sb = StringBuffer();
  sb.writeln("Jaguar ORM showcase:");

  sb.writeln('--------------');
  sb.write('Connecting ...');
  var dbPath = await getDatabasesPath();
  _adapter = SqfliteAdapter(path.join(dbPath, "test.db"));

  try {
    await _adapter.connect();
    sb.writeln(' successful!');
    sb.writeln('--------------');

    final bean = PostBean(_adapter);
    final itemBean = ItemBean(_adapter);

    // await bean.drop();
    // await itemBean.drop();

    sb.write('Creating table ...');
    await bean.createTable(ifNotExists: true);
    await itemBean.createTable(ifNotExists: true);
    sb.writeln(' successful!');
    sb.writeln('--------------');

    // Find all posts
    sb.writeln('Reading all rows ...');
    List<Post> posts = await bean.getAll();
    posts.forEach((p) => sb.writeln(p));
    sb.writeln('--------------');

    sb.writeln(' successful!');
    sb.writeln('--------------');
  } finally {
    print(sb.toString());
  }

  // runApp(SingleChildScrollView(
  //     child: Text(sb.toString(), textDirection: TextDirection.ltr)));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jaguar orm deneme",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bean = PostBean(_adapter);
  @override
  void initState() {
    super.initState();
    //denemeler();
  }

  Future<List<Post>> denemeler() async {
    final authors = await bean.getAll();
    print(authors);
    return bean.preloadAll(authors);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abarey'),
      ),
      body: FutureBuilder(
        future: denemeler(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPage(
                              which: 0,
                              myAdapter: _adapter,
                              postWillUpdate: snapshot.data[index],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        snapshot.data[index].msg,
                      ),
                    ),
                    subtitle: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data[index].items == null
                          ? 0
                          : snapshot.data[index].items.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPage(
                                  which: i + 1,
                                  myAdapter: _adapter,
                                  postWillUpdate: snapshot.data[index],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "${snapshot.data[index].items[i].msg}, id: ${snapshot.data[index].items[i].id}",
                            style: TextStyle(fontSize: 40),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return Column(
              children: <Widget>[
                Text("snapshot has not data"),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          return Column(
            children: <Widget>[
              Text("connection state not done"),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddingPage(
                myAdapter: _adapter,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Delete all
// sb.write('Removing old rows (if any) ...');
// await bean.removeAll();
// sb.writeln(' successful!');
// sb.writeln('--------------');

// Insert some posts
// sb.writeln('Inserting sample rows ...');

// var post123 = new Post.make(
//   null,
//   'Coffee?',
//   4.5,
//   false,
//   DateTime.now(),
//   [
//     new Item.make(null, 'test'),
//     new Item.make(null, 'test 2'),
//   ],
// );
// int id2 = await bean.insert(post123, cascade: true);
// sb.writeln(
//     'Inserted successfully row with id: $id2 and one to many relation!');

// sb.writeln('--------------');

// var post = new Post.make(
//   null,
//   'Coffee?',
//   4.5,
//   false,
//   DateTime.now(),
//   [
//     new Item.make(null, 'test'),
//     new Item.make(null, 'test 2'),
//   ],
// );
// int id1 = await bean.insert(post, cascade: true);
// sb.writeln(
//     'Inserted successfully row with id: $id1 and one to many relation!');

// sb.writeln('--------------');

// Find one post
// sb.writeln('Reading row with id $id1 with one to one relation...');
// Post post1 = await bean.find(id1, preload: true);
// sb.writeln(post1);
// sb.writeln('--------------');
// Update a post
// sb.write('Updating a column in row with id $id1 ...');
// await bean.updateReadField(id1, true);
// sb.writeln(' successful!');
// sb.writeln('--------------');

// // Find one post
// sb.writeln('Reading row with $id1 to check the update ...');
// post1 = await bean.find(id1);
// sb.writeln(post1);
// sb.writeln('--------------');

// sb.writeln('Removing row with id $id1 ...');
// await bean.remove(id1);
// sb.writeln('--------------');

// // Find all posts
// sb.writeln('Reading all rows ...');
// posts = await bean.getAll();
// posts.forEach((p) => sb.writeln(p));
// sb.writeln('--------------');

// sb.writeln('Removing all rows ...');
// await bean.removeAll();
// sb.writeln('--------------');

// sb.write('Closing the connection ...');
// await _adapter.close();
