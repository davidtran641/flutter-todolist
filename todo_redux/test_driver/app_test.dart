
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
        group('test add todo',  () {
          final buttonFinder = find.byValueKey('floating_button');
          final todoTextField = find.byValueKey('todo_text_field');
          final saveButton = find.byValueKey('save_button');
          final todoTitle = find.byValueKey('todo_text');

          FlutterDriver driver;
          
          setUpAll(() async {
            driver = await FlutterDriver.connect();

          });

          tearDownAll(() async {
            if(driver != null) {
              driver.close();
            }
          });

          test('Add  todo', () async {
            await driver.tap(buttonFinder);
            await driver.tap(todoTextField);
            await driver.enterText('Item 1');
            await driver.tap(saveButton);

            expect(await driver.getText(todoTitle), "Item 1");
          });
  });
}