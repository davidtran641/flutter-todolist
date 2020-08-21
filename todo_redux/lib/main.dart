import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/store.dart';
import 'package:todo_redux/model/state.dart';
import 'package:todo_redux/todolist_page.dart';


void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatefulWidget {
  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final Store<AppState> store = createStore();

  @override
  void initState() {
    super.initState();
    store.dispatch(GetListAction());
  }

  @override
  Widget build(BuildContext context) {

    return StoreProvider(
      store: this.store,
      child: MaterialApp(
        home: TodoListPage('My Todo'),
      ),
    );
  }
}