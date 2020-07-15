import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/todoitem.dart';

import 'action.dart';

abstract class _ItemViewModel {}

@immutable
class _TodoItemViewModel extends _ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemTooltip;
  final IconData deleteItemIcon;

  _TodoItemViewModel(this.title, this.onDeleteItem, this.deleteItemTooltip,
      this.deleteItemIcon);
}

@immutable
class _EmptyItemViewModel extends _ItemViewModel {
  final String hint;
  final Function(String) onCreateItem;
  final String createItemToolTip;

  _EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);
}

class _ViewModel {
  final String pageTitle;
  final List<_ItemViewModel> items;
  final Function onNewItem;
  final String newItemToolTip;
  final IconData newItemIcon;

  _ViewModel(this.pageTitle, this.items, this.onNewItem, this.newItemToolTip,
      this.newItemIcon);

  factory _ViewModel.create(Store<AppState> store) {
    List<_TodoItemViewModel> todoItems = store.state.totoList
        .map((TodoItem item) => _TodoItemViewModel(item.title, () {
              store.dispatch(RemoveItemAction(item));
              store.dispatch(SaveListAction());
            }, 'Delete', Icons.delete))
        .toList();
    List<_ItemViewModel> items = List.from(todoItems);

    if (store.state.listState == ListState.listWithNewItem) {
      print('Create new item to add');

      items.add(_EmptyItemViewModel('Add new task here', (String title) {
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(TodoItem(title)));
        store.dispatch(SaveListAction());
      }, 'Add'));
    }
    return _ViewModel('Todo', items, () {
      print("On new item");
      store.dispatch(DisplayListWithNewItemAction());
    }, 'Add new to-do item', Icons.add);
  }
}

class TodoListPage extends StatelessWidget {
  final String title;

  TodoListPage(this.title);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: Text(viewModel.pageTitle),
          ),
          body: ListView(
              children: viewModel.items
                  .map((item) => _createItemWidget(item))
                  .toList()),
          floatingActionButton: FloatingActionButton(
            onPressed: viewModel.onNewItem,
            tooltip: viewModel.newItemToolTip,
            child: Icon(viewModel.newItemIcon),
          ),
        ),
      );

  Widget _createItemWidget(_ItemViewModel item) {
    if (item is _EmptyItemViewModel) {
      return _createEmptyItemWidget(item);
    } else {
      return _createTodoItemWidget(item);
    }
  }

  Widget _createEmptyItemWidget(_EmptyItemViewModel item) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            onSubmitted: item.onCreateItem,
            autofocus: true,
            decoration: InputDecoration(hintText: item.createItemToolTip),

          )
        ],
      )
    );
  }

  Widget _createTodoItemWidget(_TodoItemViewModel item) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Text(item.title),
        FlatButton(
            onPressed: item.onDeleteItem,
            child: Icon(
              item.deleteItemIcon,
              semanticLabel: item.deleteItemTooltip,
            ))
      ])
    );
  }
}
