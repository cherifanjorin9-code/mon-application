import 'package:flutter_test/flutter_test.dart';
import 'package:kuizine_app/main.dart';

void main() {
  testWidgets('KUIZINE app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const KuizineApp());
    // Verify splash screen appears
    expect(find.text('KUIZINE'), findsOneWidget);
  });
}
