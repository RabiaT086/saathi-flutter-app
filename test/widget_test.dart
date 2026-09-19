import 'package:flutter_test/flutter_test.dart';
import 'package:saathi_app/main.dart';

void main() {
  testWidgets('Saathi App smoke test - launches cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const SaathiApp());
    expect(find.byType(SaathiApp), findsOneWidget);
  });
}