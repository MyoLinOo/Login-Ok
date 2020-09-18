import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_login/model/todo.dart';
import 'package:flutter/material.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class UpdateDialog extends StatefulWidget {
  final List<Todo> listTodo;
  final int indext;
  final String todoId;
  BuildContext context;

  UpdateDialog({this.listTodo, this.indext, this.todoId, this.context});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  TextEditingController _updateTextcontroller;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  FocusNode descroptionNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              TextFormField(
                controller: _updateTextcontroller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Enter your list",
                  icon: Icon(Icons.list),
                ),
                validator: (value) =>
                    value.isEmpty ? " Please Toch CANCEN " : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "cancel",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);

                      _updateTodo(widget.listTodo[widget.indext]);
                      updateData(_updateTextcontroller.text, widget.todoId);
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _updateTodo(Todo todo) {
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  Future updateData(String name, String todoId) {
    _updateTextcontroller.value.copyWith(text: name);
    Todo todo = new Todo(name.toString(), todoId, false);
    _database.reference().child('todo').child(todoId).update(todo.toJson());
  }
}
