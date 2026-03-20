import 'package:aurora/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Aurora Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuroraApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
