import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ellipse/main.dart';

void main() {
  testWidgets('Ellipse', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());
  });
}
