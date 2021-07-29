import 'package:falemais/screens/dashboard.dart';
import 'package:falemais/screens/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should display Scaffold when the Form is opened',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InputFormContainer()));
    final mainImage = find.byType(Scaffold);
    expect(mainImage, findsOneWidget);
  });
}
