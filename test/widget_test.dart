import 'package:flutter_test/flutter_test.dart';
import 'package:aperturetube/main.dart';

void main() {
  testWidgets('ApertureTube app launches and displays navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const ApertureTubeApp());
    await tester.pump();

    // Verify ApertureTube branding is present
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Community'), findsWidgets);
    expect(find.text('Invoices'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Portal'), findsWidgets);
  });
}
