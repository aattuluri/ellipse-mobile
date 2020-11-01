import 'package:EllipseApp/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ellipse App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());
  });
}
