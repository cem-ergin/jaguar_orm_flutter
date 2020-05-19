import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:moor_deneme/models/item/item.dart';
import 'package:moor_deneme/models/post/post.dart';

class AddItemPage extends StatefulWidget {
  final SqfliteAdapter myAdapter;
  final Post postWillUpdate;
  AddItemPage(
      {Key key, @required this.myAdapter, @required this.postWillUpdate})
      : super(key: key);

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  PostBean bean;

  @override
  void initState() {
    super.initState();
    bean = PostBean(widget.myAdapter);
  }

  TextEditingController cont1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: cont1,
          ),
          RaisedButton(
            onPressed: () {
              try {
                widget.postWillUpdate.items.add(Item.make(null, cont1.text));
                bean.upsert(widget.postWillUpdate, cascade: true);
                print(widget.postWillUpdate.items);
                print("updated?");
              } catch (e) {
                print("update yaparken hata olustu: " + e.toString());
              }
            },
          )
        ],
      ),
    );
  }
}
