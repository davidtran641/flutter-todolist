import 'dart:async';

import 'package:redux/redux.dart';
import 'package:todo_redux/model/state.dart';

import 'redux/action.dart';


List<Middleware<AppState>> createStoreMiddleWare() {
  return [TypedMiddleware<AppState, SaveListAction>(_saveList)];
}

Future _saveList(Store<AppState> state, SaveListAction action, NextDispatcher next) async {
  await Future.sync(() => Duration(seconds: 3));
  next(action);
}