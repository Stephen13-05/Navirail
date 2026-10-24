import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navirail_app/main.dart';
void main() {
  testWidgets('App opens and completes its splash screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('NaviRail'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
