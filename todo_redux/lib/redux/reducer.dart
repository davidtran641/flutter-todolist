import 'package:redux/redux.dart';
import 'package:todo_redux/model/state.dart';
import 'package:todo_redux/model/todoitem.dart';

import 'action.dart';

AppState appReducer(AppState state, action) => AppState(
    todoListReducer(state.todoList, action),
    listStateReducer(state.listState, action));

final Reducer<List<TodoItem>> todoListReducer = combineReducers([
  TypedReducer<List<TodoItem>, AddItemAction>(_addItem),
  TypedReducer<List<TodoItem>, RemoveItemAction>(_removeItem),
  TypedReducer<List<TodoItem>, LoadedTodoListAction>(_loadedItem),
]);

List<TodoItem> _addItem(List<TodoItem> todoList, AddItemAction action) =>
    List.unmodifiable(List.from(todoList)..add(action.item));

List<TodoItem> _removeItem(List<TodoItem> todoList, RemoveItemAction action) =>
    List.unmodifiable(List.from(todoList)..remove(action.item));

List<TodoItem> _loadedItem(
        List<TodoItem> todoList, LoadedTodoListAction action) =>
    action.todoList;

final Reducer<ListState> listStateReducer = combineReducers<ListState>([
  TypedReducer<ListState, DisplayListOnlyAction>(_displayListOnly),
  TypedReducer<ListState, DisplayListWithNewItemAction>(_displayListWithNewItem)
]);

ListState _displayListOnly(ListState listState, DisplayListOnlyAction action) =>
    ListState.listOnly;

ListState _displayListWithNewItem(
        ListState listState, DisplayListWithNewItemAction action) =>
    ListState.listWithNewItem;
