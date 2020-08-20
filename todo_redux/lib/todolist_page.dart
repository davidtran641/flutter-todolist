import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/model/state.dart';
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
  ScrollController scrollController;

  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    scrollController = ScrollController();
    curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
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
    return ListView.builder(
      key: Key('todo_list'),
      padding: EdgeInsets.only(bottom: 100),
      controller: scrollController,
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) =>
          _createItemWidget(context, viewModel.items[index]),
    );
  }

  FloatingActionButton _createFloatingButton(ViewModel viewModel) =>
      FloatingActionButton(
        key: Key('floating_button'),
        onPressed: () {
          _handleAddButtonClicked(viewModel);
        },
        tooltip: viewModel.newItemToolTip,
        child: Icon(viewModel.newItemIcon),
      );

  void _handleAddButtonClicked(ViewModel viewModel) {
    viewModel.onNewItem.call();
    animationController.forward();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.fastLinearToSlowEaseIn);
    });


  }

  Widget _createItemWidget(BuildContext context, ItemViewModel item) {
    print('Rebuild item widget');
    if (item is EmptyItemViewModel) {
      return FadeTransition(
        opacity: curve,
        child: AddItemWidget(viewModel: item),
      );
    } else if (item is TodoItemViewModel) {
      return TodoItemWidget(viewModel: item);
    }
  }
}

class AddItemWidget extends StatefulWidget {
  final EmptyItemViewModel viewModel;

  const AddItemWidget({Key key, this.viewModel}) : super(key: key);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      title: TextField(
        key: Key('todo_text_field'),
        controller: textFieldController,
        onSubmitted: widget.viewModel.onCreateItem,
        autofocus: true,
        decoration:
            InputDecoration(hintText: widget.viewModel.createItemToolTip),
      ),
      trailing: IconButton(
        key: Key('save_button'),
        onPressed: () {
          widget.viewModel.onCreateItem(textFieldController.text);
        },
        icon: Icon(
          Icons.save,
          semanticLabel: 'Save',
        ),
      ),
    );
  }
}

class TodoItemWidget extends StatelessWidget {
  final TodoItemViewModel viewModel;

  const TodoItemWidget({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      title: Text(
        viewModel.title,
        key: Key('todo_text'),
        style: Theme.of(context).textTheme.subtitle1,
      ),
      trailing: IconButton(
        key: Key('delete_button'),
        onPressed: viewModel.onDeleteItem,
        icon: Icon(
          viewModel.deleteItemIcon,
          semanticLabel: viewModel.deleteItemTooltip,
        ),
      ),
    );
  }
}
