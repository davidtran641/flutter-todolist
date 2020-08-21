import 'package:todo_redux/model/todoitem.dart';

class AppState {
  final List<TodoItem> todoList;
  final ListState listState;

  AppState(this.todoList, this.listState);

  factory AppState.initial() =>
      AppState(List.unmodifiable([]), ListState.listOnly);

  AppState.fromJson(Map json) :
      todoList = (json['todoList'] as List).map((e) => TodoItem.fromJson(e)).toList(),
      listState = ListState.listOnly;

  Map toJson()  =>  {
    'todoList': todoList,
  };
}

enum ListState { listOnly, listWithNewItem }
