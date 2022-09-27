import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/fetchDetails.dart';
import 'package:matrix/login.dart';
import 'package:matrix/scanner.dart';

void main() {
  testWidgets('My App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MaterialApp(
      home: ScannerPage(),
    ));

    // await tester.pumpAndSettle();
    expect(find.byType(ScannerPage), findsOneWidget);
  });
}