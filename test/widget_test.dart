import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eduquest/main.dart';

void main() {
  testWidgets('Navigation bar test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial page is "Lesson Page".
    expect(find.text('Lesson Page'), findsOneWidget);
    expect(find.text('Assessment Page'), findsNothing);
    expect(find.text('Quiz Page'), findsNothing);

    // Tap the "Assessments" icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.assignment));
    await tester.pump();

    // Verify that the page changes to "Assessment Page".
    expect(find.text('Lesson Page'), findsNothing);
    expect(find.text('Assessment Page'), findsOneWidget);
    expect(find.text('Quiz Page'), findsNothing);

    // Tap the "Quiz" icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.quiz));
    await tester.pump();

    // Verify that the page changes to "Quiz Page".
    expect(find.text('Lesson Page'), findsNothing);
    expect(find.text('Assessment Page'), findsNothing);
    expect(find.text('Quiz Page'), findsOneWidget);

    // Tap the "Lessons" icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.school));
    await tester.pump();

    // Verify that the page changes back to "Lesson Page".
    expect(find.text('Lesson Page'), findsOneWidget);
    expect(find.text('Assessment Page'), findsNothing);
    expect(find.text('Quiz Page'), findsNothing);
  });
}
