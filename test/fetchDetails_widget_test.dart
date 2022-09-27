import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/fetchDetails.dart';
import 'package:matrix/login.dart';

void main() {
  testWidgets('My App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: FetchDetails(),
    ));

    // await tester.pumpAndSettle();
    expect(find.byType(FetchDetails), findsOneWidget);

    var elevatedButton = find.byType(ElevatedButton);
    expect(elevatedButton, findsOneWidget);

    await tester.tap(elevatedButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}