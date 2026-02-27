import 'package:flutter_test/flutter_test.dart';
import 'package:luno_quit_smoking_app/app.dart';

void main() {
  testWidgets('Uygulama başlatılabilir', (WidgetTester tester) async {
    await tester.pumpWidget(const LunoApp());
    expect(find.text('Luno 🫁'), findsOneWidget);
  });
}
