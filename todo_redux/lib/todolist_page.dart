import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/view_model.dart';

class TodoListPage extends StatelessWidget {
  final String title;

  TodoListPage(this.title);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.make(store),
      builder: (BuildContext context, ViewModel viewModel) {
        print('rebuild todolist page');
        return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.pageTitle),
            ),
            body: _createListView(viewModel),
            floatingActionButton: _createFloatingButton(viewModel));
      },
    );
  }

  ListView _createListView(ViewModel viewModel) {
    return ListView(
        children:
        viewModel.items.map((item) => _createItemWidget(item)).toList());
  }

  FloatingActionButton _createFloatingButton(ViewModel viewModel) =>
      FloatingActionButton(
        onPressed: viewModel.onNewItem,
        tooltip: viewModel.newItemToolTip,
        child: Icon(viewModel.newItemIcon),
      );

  Widget _createItemWidget(ItemViewModel item) {
    print('Rebuild item widget');
    if (item is EmptyItemViewModel) {
      return _createEmptyItemWidget(item);
    } else {
      return _createTodoItemWidget(item);
    }
  }

  Widget _createEmptyItemWidget(EmptyItemViewModel item) {
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
        ));
  }

  Widget _createTodoItemWidget(TodoItemViewModel item) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Text(item.title),
            FlatButton(
                onPressed: item.onDeleteItem,
                child: Icon(
                  item.deleteItemIcon,
                  semanticLabel: item.deleteItemTooltip,
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }
}
