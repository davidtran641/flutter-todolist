import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/action.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/todoitem.dart';
import 'package:todo_redux/view_model.dart';

class MockStore extends Mock implements Store<AppState> {}

void main() {
  group('ViewModel', (){

    MockStore store;

    setUp(() {
      store = MockStore();
      when(store.state).thenReturn(AppState.initial());
    });

    test('make view model', (){

      final viewModel = ViewModel.make(store);
      expect(viewModel.pageTitle, 'Todo');
      expect(viewModel.newItemToolTip, 'Add new to-do item');
      expect(viewModel.newItemIcon, Icons.add);
      viewModel.onNewItem.call();

      verify(store.dispatch(isInstanceOf<DisplayListWithNewItemAction>())).called(1);
    });

    test('make view model - listWithNewItem', () {
      when(store.state).thenReturn(AppState([], ListState.listWithNewItem));

      final viewModel = ViewModel.make(store);
      expect(viewModel.items[0] is EmptyItemViewModel, true);
    });
  });

  group('TodoItemViewModel', () {
    MockStore store;

    setUp(() {
      store = MockStore();
      when(store.state).thenReturn(AppState.initial());
    });

    test('make view model', () {
      final item = TodoItem('Task 1');

      final itemViewModel = TodoItemViewModel.make(store, item);
      expect(itemViewModel.title, 'Task 1');
      expect(itemViewModel.deleteItemTooltip, 'Delete');
      expect(itemViewModel.deleteItemIcon, Icons.delete);

      itemViewModel.onDeleteItem.call();
      verify(store.dispatch(isInstanceOf<RemoveItemAction>())).called(1);
      verify(store.dispatch(isInstanceOf<SaveListAction>())).called(1);
    });

    test('make empty view model', () {
      final itemViewModel = EmptyItemViewModel.make(store);
      expect(itemViewModel.hint, 'Add new task here');
      expect(itemViewModel.createItemToolTip, 'Add');

      itemViewModel.onCreateItem.call('New task');
      verify(store.dispatch(isInstanceOf<DisplayListOnlyAction>())).called(1);
      verify(store.dispatch(isInstanceOf<AddItemAction>())).called(1);
      verify(store.dispatch(isInstanceOf<SaveListAction>())).called(1);
    });
  });
}