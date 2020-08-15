import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'check_widget_visible.dart';

void main() {
  group('test profiling', () {
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

    test('Profiling', () async {
      for (int i = 0; i < 20; i++) {
        await addItem('Item $i');
      }

      final todoList = find.byValueKey('todo_list');
      final firstItemFinder = find.text('Item 0');

      final timeline = await driver.traceAction(() async {
        await driver.scrollUntilVisible(
          todoList,
          firstItemFinder,
          dyScroll: 300.0,
        );

        expect(await isPresent(firstItemFinder, driver), true);
      });

      final summary = new TimelineSummary.summarize(timeline);
      await summary.writeSummaryToFile('scrolling_summary', pretty: true);
      await summary.writeTimelineToFile('scrolling_timeline', pretty: true);
    });
  });
}