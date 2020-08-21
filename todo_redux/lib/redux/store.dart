
import 'package:redux/redux.dart';
import 'package:todo_redux/model/state.dart';
import 'package:todo_redux/redux/reducer.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import '../middleware.dart';

Store<AppState> createStore() {
  return DevToolsStore<AppState>(
      appReducer,
      initialState: AppState.initial(),
      middleware: createStoreMiddleWare()
  );
}
