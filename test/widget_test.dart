import 'package:flutter_test/flutter_test.dart';
import 'package:tugasmopro_yosep_077/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KantinBuSari());
    expect(find.text('Kantin Bu Sari'), findsWidgets);
  });
}
