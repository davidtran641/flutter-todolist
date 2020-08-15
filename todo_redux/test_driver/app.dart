
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_redux/main.dart' as app;

void main() {
  var textInput = TestTextInput();
  Function(String) handler = (message) {
    switch(message){
      case 'done':
        textInput.receiveAction(TextInputAction.done);
        break;
      default:
        break;
    }
  };

  enableFlutterDriverExtension(handler: handler);
  app.main();
}