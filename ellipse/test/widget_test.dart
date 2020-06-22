import 'package:flutter_test/flutter_test.dart';
import 'package:ellipse/main.dart';

void main() {
  testWidgets('ellipse', (WidgetTester tester) async {
    await tester.pumpWidget(App());
  });
}
