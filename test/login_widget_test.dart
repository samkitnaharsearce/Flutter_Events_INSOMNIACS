import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/QRPage.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/login.dart';
import 'package:matrix/main.dart';

void main() {
  testWidgets('My App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Login(sourceLink: "https://linkedin.com/login"),
    ));

    // await tester.pumpAndSettle();
    expect(find.byType(Login), findsOneWidget);

  });
}