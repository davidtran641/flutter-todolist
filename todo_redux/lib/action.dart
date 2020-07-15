import 'package:todo_redux/todoitem.dart';

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

class SaveListAction {

}