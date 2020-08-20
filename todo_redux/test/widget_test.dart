import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_redux/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    await tester.pumpWidget(TodoListApp());

    expect(find.byTooltip('Add new to-do item'), findsOneWidget);

    await tester.tap(find.byTooltip('Add new to-do item'));
    tester.binding.scheduleWarmUpFrame();

    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);

    // Add item 1
    await tester.enterText(find.byType(TextField), "Item 1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('Item 1'), findsOneWidget);

    // Remove item
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Item 1'), findsNothing);

  });
}
