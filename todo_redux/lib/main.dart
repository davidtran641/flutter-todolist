import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/reducer.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/todolist_page.dart';

import 'middleware.dart';

void main() {
  runApp(TodoListApp());
}


class TodoListApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: createStoreMiddleWare());

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