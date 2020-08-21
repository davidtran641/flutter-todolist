import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/model/state.dart';
import 'package:todo_redux/model/todoitem.dart';

import 'redux/action.dart';

class ViewModel {
  final String pageTitle;
  final List<ItemViewModel> items;
  final Function onNewItem;
  final String newItemToolTip;
  final IconData newItemIcon;
  final Store<AppState> store;

  ViewModel({
    this.pageTitle,
    this.items,
    this.onNewItem,
    this.newItemToolTip,
    this.newItemIcon,
    this.store,
  });

  factory ViewModel.make(Store<AppState> store) {
    _onNewItem() {
      print("On new item");
      store.dispatch(DisplayListWithNewItemAction());
    }

    List<TodoItemViewModel> todoItems = store.state.todoList
        .map((item) => TodoItemViewModel.make(store, item))
        .toList();
    List<ItemViewModel> items = List.from(todoItems);

    if (store.state.listState == ListState.listWithNewItem) {
      print('Create new item to add');
      items.add(EmptyItemViewModel.make(store));
    }

    return ViewModel(
        pageTitle: 'Todo',
        items: items,
        onNewItem: _onNewItem,
        newItemToolTip: 'Add new to-do item',
        newItemIcon: Icons.add,
        store: store,
    );
  }
}

abstract class ItemViewModel {}

@immutable
class TodoItemViewModel extends ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemTooltip;
  final IconData deleteItemIcon;

  TodoItemViewModel({
    this.title,
    this.onDeleteItem,
    this.deleteItemTooltip,
    this.deleteItemIcon,
  });

  factory TodoItemViewModel.make(Store<AppState> store, TodoItem item) {
    _onDeleteItem() {
      store.dispatch(RemoveItemAction(item));
      store.dispatch(SaveListAction());
    }

    return TodoItemViewModel(
      title: item.title,
      onDeleteItem: _onDeleteItem,
      deleteItemTooltip: 'Delete',
      deleteItemIcon: Icons.delete,
    );
  }
}

@immutable
class EmptyItemViewModel extends ItemViewModel {
  final String hint;
  final Function(String) onCreateItem;
  final String createItemToolTip;

  EmptyItemViewModel({
    this.hint,
    this.onCreateItem,
    this.createItemToolTip,
  });

  factory EmptyItemViewModel.make(Store<AppState> store) {
    _onCreateItem(String title) {
      store.dispatch(DisplayListOnlyAction());
      store.dispatch(AddItemAction(TodoItem(title)));
      store.dispatch(SaveListAction());
    }

    return EmptyItemViewModel(
      hint: 'Add new task here',
      onCreateItem: _onCreateItem,
      createItemToolTip: 'Add',
    );
  }
}
