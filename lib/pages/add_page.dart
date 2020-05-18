import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:moor_deneme/models/item/item.dart';
import 'package:moor_deneme/models/post/post.dart';

class AddingPage extends StatefulWidget {
  final SqfliteAdapter myAdapter;
  AddingPage({Key key, @required this.myAdapter}) : super(key: key);

  @override
  AddingPageState createState() => AddingPageState();
}

class AddingPageState extends State<AddingPage> {
  PostBean bean;

  @override
  void initState() {
    super.initState();
    bean = PostBean(widget.myAdapter);
  }

  TextEditingController cont1 = TextEditingController();
  TextEditingController cont2 = TextEditingController();
  TextEditingController cont3 = TextEditingController();
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
          TextField(
            controller: cont2,
          ),
          TextField(
            controller: cont3,
          ),
          RaisedButton(
            onPressed: () {
              var post = new Post.make(
                null,
                cont1.text,
                4.5,
                false,
                DateTime.now(),
                [
                  new Item.make(null, cont2.text),
                  new Item.make(null, cont3.text),
                ],
              );
              print(post);
              bean.insert(post, cascade: true);
            },
          )
        ],
      ),
    );
  }
}
