import 'dart:async';
import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_redux/model/state.dart';

import 'redux/action.dart';

List<Middleware<AppState>> createStoreMiddleWare() {
  return [
    TypedMiddleware<AppState, SaveListAction>(_saveList),
    TypedMiddleware<AppState, GetListAction>(_loadFromPrefsMiddleware),
  ];
}

Future _saveList(
    Store<AppState> store, SaveListAction action, NextDispatcher next) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var string = json.encode(store.state.toJson());
  await sharedPreferences.setString('itemsState', string);
}

void _loadFromPrefsMiddleware(
    Store<AppState> store, GetListAction action, NextDispatcher next) async {
  await _loadFromPrefs().then(
      (appState) => store.dispatch(LoadedTodoListAction(appState.todoList)));
}

Future<AppState> _loadFromPrefs() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var string = sharedPreferences.get("itemsState");
  if (string != null) {
    Map map = json.decode(string);
    return AppState.fromJson(map);
  }
  return AppState.initial();
}
