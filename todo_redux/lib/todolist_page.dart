import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/view_model.dart';

class TodoListPage extends StatefulWidget {
  final String title;

  TodoListPage(this.title);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  CurvedAnimation curve;

  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.make(store),
      builder: (BuildContext context, ViewModel viewModel) {
        print('rebuild todo list page');
        return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.pageTitle),
            ),
            body: _createListView(context, viewModel),
            floatingActionButton: _createFloatingButton(viewModel));
      },
    );
  }

  ListView _createListView(BuildContext context, ViewModel viewModel) {
    return ListView(
        children: viewModel.items
            .map((item) => _createItemWidget(context, item))
            .toList());
  }

  FloatingActionButton _createFloatingButton(ViewModel viewModel) =>
      FloatingActionButton(
        key: Key('floating_button'),
        onPressed: () {
          viewModel.onNewItem.call();
          animationController.forward();
        },
        tooltip: viewModel.newItemToolTip,
        child: Icon(viewModel.newItemIcon),
      );

  Widget _createItemWidget(BuildContext context, ItemViewModel item) {
    print('Rebuild item widget');
    if (item is EmptyItemViewModel) {
      return _createEmptyItemWidget(context, item);
    } else {
      return _createTodoItemWidget(context, item);
    }
  }

  Widget _createEmptyItemWidget(BuildContext context, EmptyItemViewModel item) {
    final textFieldController = TextEditingController();

    return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            FadeTransition(
              opacity: curve,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      key: Key('todo_text_field'),
                      controller: textFieldController,
                      onSubmitted: item.onCreateItem,
                      autofocus: true,
                      decoration: InputDecoration(hintText: item.createItemToolTip),
                    ),
                  ),
                  FlatButton(
                      key: Key('save_button'),
                      onPressed: (){
                        item.onCreateItem(textFieldController.text);
                      },
                      child: Icon(
                        Icons.save,
                        semanticLabel: 'Save',
                      ))
                ],
              ),
            )
          ],
        ));
  }

  Widget _createTodoItemWidget(BuildContext context, TodoItemViewModel item) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              item.title,
              key: Key('todo_text'),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            FlatButton(
                key: Key('delete_button'),
                onPressed: item.onDeleteItem,
                child: Icon(
                  item.deleteItemIcon,
                  semanticLabel: item.deleteItemTooltip,
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
