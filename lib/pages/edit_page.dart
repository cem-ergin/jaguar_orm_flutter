import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:moor_deneme/models/post/post.dart';

class EditPage extends StatefulWidget {
  final SqfliteAdapter myAdapter;
  final Post postWillUpdate;
  final int which;
  EditPage(
      {Key key,
      @required this.myAdapter,
      @required this.postWillUpdate,
      @required this.which})
      : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  PostBean bean;
  @override
  void initState() {
    super.initState();
    bean = PostBean(widget.myAdapter);
  }

  TextEditingController cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: cont,
          ),
          RaisedButton(
            onPressed: () {
              try {
                if (widget.which == 0) {}
                widget.which == 0
                    ? widget.postWillUpdate.msg = cont.text
                    : widget.which == 1
                        ? widget.postWillUpdate.items[0].msg = cont.text
                        : widget.postWillUpdate.items[1].msg = cont.text;
                bean.update(widget.postWillUpdate, cascade: true);
                print("updated?");
              } catch (e) {
                print("update yaparken hata olustu: " + e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}
