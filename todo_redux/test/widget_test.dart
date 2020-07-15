import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_redux/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    await tester.pumpWidget(TodoListApp());

    expect(find.byTooltip('Add new to-do item'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
  });
}
