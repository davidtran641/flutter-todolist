import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/todoitem.dart';

import 'action.dart';

class ViewModel {
  final String pageTitle;
  final List<ItemViewModel> items;
  final Function onNewItem;
  final String newItemToolTip;
  final IconData newItemIcon;

  ViewModel(this.pageTitle, this.items, this.onNewItem, this.newItemToolTip,
      this.newItemIcon);

  factory ViewModel.make(Store<AppState> store) {
    List<TodoItemViewModel> todoItems = store.state.todoList
        .map((item) => TodoItemViewModel.make(store, item))
        .toList();
    List<ItemViewModel> items = List.from(todoItems);

    if (store.state.listState == ListState.listWithNewItem) {
      print('Create new item to add');
      items.add(EmptyItemViewModel.make(store));
    }
    return ViewModel('Todo', items, () {
      print("On new item");
      store.dispatch(DisplayListWithNewItemAction());
    }, 'Add new to-do item', Icons.add);
  }
}

abstract class ItemViewModel {}

@immutable
class TodoItemViewModel extends ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemTooltip;
  final IconData deleteItemIcon;

  TodoItemViewModel(this.title, this.onDeleteItem, this.deleteItemTooltip,
      this.deleteItemIcon);

  factory TodoItemViewModel.make(Store<AppState> store, TodoItem item) =>
      TodoItemViewModel(item.title, () {
        store.dispatch(RemoveItemAction(item));
        store.dispatch(SaveListAction());
      }, 'Delete', Icons.delete);
}

@immutable
class EmptyItemViewModel extends ItemViewModel {
  final String hint;
  final Function(String) onCreateItem;
  final String createItemToolTip;

  EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);

  factory EmptyItemViewModel.make(Store<AppState> store) =>
      EmptyItemViewModel('Add new task here', (String title) {
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(TodoItem(title)));
        store.dispatch(SaveListAction());
      }, 'Add');
}
