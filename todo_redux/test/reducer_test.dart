import 'package:flutter_test/flutter_test.dart';
import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/reducer.dart';
import 'package:todo_redux/model/state.dart';
import 'package:todo_redux/model/todoitem.dart';

void main() {
  group('Reducer', () {
    test('DisplayListWithNewItemAction', () {
      expect(appReducer(AppState.initial(), DisplayListWithNewItemAction()).listState, ListState.listWithNewItem);
      expect(appReducer(AppState.initial(), DisplayListWithNewItemAction()).todoList, []);
    });

    test('DisplayListOnlyAction', () {
      expect(appReducer(AppState.initial(), DisplayListOnlyAction()).listState, ListState.listOnly);
      expect(appReducer(AppState([], ListState.listWithNewItem), DisplayListOnlyAction()).todoList, []);
    });

    test('AddItemAction', () {
      final item = TodoItem('task 1');
      expect(appReducer(AppState.initial(), AddItemAction(item)).todoList, [item]);
    });

    test('RemoveItemAction', () {
      final item = TodoItem('task 1');
      final item2 = TodoItem('task 2');
      expect(appReducer(AppState([item, item2], ListState.listWithNewItem), RemoveItemAction(item)).todoList, [item2]);
    });
  });

}