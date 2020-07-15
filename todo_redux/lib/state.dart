import 'package:todo_redux/todoitem.dart';

class AppState {
  final List<TodoItem> totoList;
  final ListState listState;

  AppState(this.totoList, this.listState);

  factory AppState.initial() =>
      AppState(List.unmodifiable([]), ListState.listOnly);
}

enum ListState { listOnly, listWithNewItem }
