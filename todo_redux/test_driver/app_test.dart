import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<bool> isPresent(SerializableFinder finder, FlutterDriver driver,
    {Duration timeout = const Duration(milliseconds: 100)}) async {
  try {
    await driver.waitFor(finder, timeout: timeout);
    return true;
  } catch (e) {
    return false;
  }
}

void main() {
  group('test add todo', () {
    final todoTitle = find.byValueKey('todo_text');
    final deleteButton = find.byValueKey('delete_button');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    Future<void> addItem(String text) async {
      final buttonFinder = find.byValueKey('floating_button');
      final todoTextField = find.byValueKey('todo_text_field');
      final saveButton = find.byValueKey('save_button');

      await driver.tap(buttonFinder);
      await driver.tap(todoTextField);
      await driver.enterText(text);
      await driver.tap(saveButton);
    }

    test('Add todo', () async {
      // Add item
      await addItem('Item 1');

      expect(await driver.getText(todoTitle), "Item 1");

      // Remove item
      await driver.tap(deleteButton);

      expect(await isPresent(todoTitle, driver), false);
    });

    test('Add todo 2', () async {
      await addItem('Item 1');
      await addItem('Item 2');
      await addItem('Item 3');

      expect(await isPresent(find.text('Item 1'), driver), true);
      expect(await isPresent(find.text('Item 2'), driver), true);
      expect(await isPresent(find.text('Item 3'), driver), true);
      expect(await isPresent(find.text('Non existent item'), driver), false);
    });

    test('Add long list', () async {
      for (int i = 0; i < 15; i++) {
        await addItem('Item $i');
      }

      final todoList = find.byValueKey('todo_list');
      final firstItemFinder = find.text('Item 0');
      await driver.scrollUntilVisible(
        todoList,
        firstItemFinder,
        dyScroll: 300.0,
      );
      expect(await isPresent(firstItemFinder, driver), true);
    });
  });
}
