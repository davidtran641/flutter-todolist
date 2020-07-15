import 'package:redux/redux.dart';
import 'package:todo_redux/state.dart';
import 'package:todo_redux/todoitem.dart';

import 'action.dart';

AppState appReducer(AppState state, action) =>
    AppState(todoListReducer(state.totoList, action),
        listStateReducer(state.listState, action));

final Reducer<List<TodoItem>> todoListReducer = combineReducers(
    [TypedReducer<List<TodoItem>, AddItemAction>(_addItem),
      TypedReducer<List<TodoItem>, RemoveItemAction>(_removeItem)]);

List<TodoItem> _addItem(List<TodoItem> todoList, AddItemAction action) =>
    List.unmodifiable(List.from(todoList)
      ..add(action.item));

List<TodoItem> _removeItem(List<TodoItem> todoList, RemoveItemAction action) =>
    List.unmodifiable(List.from(todoList)
      ..remove(action.item));

final Reducer<ListState> listStateReducer = combineReducers<ListState>([
  TypedReducer<ListState, DisplayListOnlyAction>(_displayListOnly),
  TypedReducer<ListState, DisplayListWithNewItemAction>(
      _displayListWithNewItem)
]);

ListState _displayListOnly(ListState listState, DisplayListOnlyAction action) =>
    ListState.listOnly;

ListState _displayListWithNewItem(ListState listState,
    DisplayListWithNewItemAction action) => ListState.listWithNewItem;