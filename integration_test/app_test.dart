import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:matrix/QRPage.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/main.dart' as app;

void main() {
  // Binding has not yet been initialized.
  // The "instance" getter on the WidgetsBinding binding mixin is only available once that binding has been initialized.
  // final binding = IntegrationTestWidgetsFlutterBinding
  //     .ensureInitialized() as IntegrationTestWidgetsFlutterBinding;
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  // final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Testing App Integration Tests', () {

    testWidgets('starts with App.main()', (tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byType(QRPage), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      var button = find.byType(ElevatedButton);
      tester.tap(button);
      await tester.pumpAndSettle(Duration(seconds: 5));


    });
  });
}