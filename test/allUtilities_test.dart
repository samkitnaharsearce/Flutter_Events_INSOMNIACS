import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailer/mailer.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/allUtilities.dart';
import 'package:mockito/mockito.dart';
// import 'package:mocktail/mocktail.dart';

abstract class MockPersistentConnection implements PersistentConnection {
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<SendReport> send(Message message) {
    DateTime now = DateTime.now();
    return Future.value(SendReport(message, now, now, now));
  }

}

void main() {
  group('allUtilities Test', (){

    test("Verify read returns values when login_status = 'true'. ", () {
      Future<bool> ret = SendEmail("mawaris99@gmail.com", "www.linkedin.com", "mabdulwaris99@gmail.com", "www.linkedin.com");
      print(ret);
      expect(ret, Future<bool>.value(false));

    });
  });
}