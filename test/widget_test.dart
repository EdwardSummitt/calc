import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shmert/main.dart';

void main() {
  testWidgets('calculates a sum', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('7'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.byKey(const Key('display')), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('calculates 2 plus 2 as 4', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '4');
  });

  testWidgets('clears the display', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('9'));
    await tester.tap(find.text('AC'));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '0');
  });

  testWidgets('handles division by zero', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('8'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.widgetWithText(TextButton, '0'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, 'Error');
  });

  testWidgets('calculates subtraction', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('9'));
    await tester.tap(find.text('-'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '5');
  });

  testWidgets('calculates multiplication', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('6'));
    await tester.tap(find.text('x'));
    await tester.tap(find.text('7'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '42');
  });

  testWidgets('calculates decimal values', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('1'));
    await tester.tap(find.text('.'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('.'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '4');
  });

  testWidgets('converts a number to a percent', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('5'));
    await tester.tap(find.widgetWithText(TextButton, '0'));
    await tester.tap(find.text('%'));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '0.5');
  });
}
