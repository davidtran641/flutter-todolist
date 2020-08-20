import 'package:todo_redux/model/todoitem.dart';

class AppState {
  final List<TodoItem> todoList;
  final ListState listState;

  AppState(this.todoList, this.listState);

  factory AppState.initial() =>
      AppState(List.unmodifiable([]), ListState.listOnly);
}

enum ListState { listOnly, listWithNewItem }
