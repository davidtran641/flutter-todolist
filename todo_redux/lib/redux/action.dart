import 'package:todo_redux/model/todoitem.dart';

class DisplayListWithNewItemAction {}

class DisplayListOnlyAction {}

class AddItemAction {
  final TodoItem item;

  AddItemAction(this.item);
}

class RemoveItemAction {
  final TodoItem item;

  RemoveItemAction(this.item);
}

class SaveListAction {}

class GetListAction {}

class LoadedTodoListAction {
  final List<TodoItem> todoList;
  LoadedTodoListAction(this.todoList);
}