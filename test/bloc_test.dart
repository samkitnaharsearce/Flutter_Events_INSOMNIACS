import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:matrix/allUtilities.dart';
import 'package:matrix/bloc/login/login_bloc.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockSecureStorage extends Mock implements FlutterSecureStorage{}

@GenerateMocks([MockSecureStorage])
void main(){
  group('LoginBloc', () {

    test("Verify read returns values when login_status = 'true'. ", () {
      var storeMock = MockSecureStorage();
      var service = SecureStorageService(storage: storeMock);

      when(storeMock.read(key: 'login_status')).thenAnswer((_) => Future.value("true"));

      expect("true", service.read(key: "dummy"));
      verify(storeMock.read(key: 'login_status')).called(1);
    });
    //
    // blocTest<LoginBloc, LoginState>(
    //   'emits [] when nothing is added',
    //   build: () => LoginBloc(),
    //   expect: () => [],
    // );
    //
    // blocTest<LoginBloc, LoginState>(
    //   'emits [1] when IsLoggedInEvent is added',
    //   build: () => LoginBloc(),
    //   act: (bloc) => bloc.add(IsLoggedInEvent()),
    //   expect: () => [],
    // );

    blocTest<LoginBloc, LoginState>(
      'Emits EndingLoginState when EndingLoginEvent is added',
      build: () => LoginBloc(),
      act: (bloc) => bloc.add(EndingLoginEvent()),
      expect: () => [EndingLoginState()],
      wait: const Duration(seconds: 5),
    );

  });
}