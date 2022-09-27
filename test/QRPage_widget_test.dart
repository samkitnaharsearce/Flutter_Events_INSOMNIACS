import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/QRPage.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/fetchDetails.dart';
import 'package:matrix/main.dart';
import 'package:matrix/scanner.dart';
import 'package:mockito/mockito.dart';

import 'bloc_test.dart';

class MockCounterBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}



void main() {
  testWidgets('My App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    var mockBlock = MockLoginBloc();

    whenListen(mockBlock, Stream.fromIterable([LoginInitial(), NewLogInState()/*const LoggedInState(qrData: '{"urn":"www.123movies.com","email":"waris69@gmail.com"')*/]));

    // await tester.pumpWidget(MaterialApp(
    //   home: BlocProvider(
    //           create: (context) => LoginBloc()..add(const EndingLoginEvent()),
    //           child: QRPage(),
    //         ),
    // ));
    await tester.pumpWidget(MaterialApp(
        routes: {
          "/QR" : (context) => QRPage(),
          "/fetchDetails" : (context) => const FetchDetails(),
          "/scanner" : (context) => ScannerPage(),
        },
        home: QRPage()
    ));

    // await tester.pumpAndSettle();

    whenListen(mockBlock, Stream.fromIterable([NewLogInState()]), initialState: LoginInitial());
    expect(mockBlock.state, equals(LoginInitial()));

    // var state = tester.state(find.byType(QRPage));
    // print("My state: $state");
    // await tester.pumpAndSettle();

    // when(() => mockBlock.state).thenReturn(
    //   LoggedInState(qrData: '{"urn":"www.123movies.com","email":"waris69@gmail.com"') // the desired state
    // );

    // Assert that the stubbed stream is emitted.
    await expectLater(mockBlock.stream, emitsInOrder([NewLogInState(), LoggedInState(qrData: "waris")]));

    // Assert that the current state is in sync with the stubbed stream.
    await tester.pump(Duration(seconds: 2));
    expect(mockBlock.state, equals(const NewLogInState()));

    await tester.pump(Duration(seconds: 2));
    expect(mockBlock.state, equals(const LoggedInState(qrData: "waris")));

    print("No Error After this.");

    expect(find.byType(QRPage), findsOneWidget);
    // await tester.pump();

    expect(find.byType(Card), findsOneWidget);
    // expect(find.byType(ElevatedButton), findsOneWidget);

    tester.allWidgets.forEach((element) {print(element);});

    // expect(find.text("Login to Continue"), findsOneWidget);
  });
}