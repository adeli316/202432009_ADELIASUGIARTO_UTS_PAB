import 'package:flutter_test/flutter_test.dart';
import 'package:myduit/main.dart';

void main() {
  testWidgets('MyDuit menampilkan beranda', (WidgetTester tester) async {
    await tester.pumpWidget(const MyDuitApp());
    expect(find.text('MyDuit'), findsOneWidget);
    expect(find.text('Transaksi'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
  });
}
