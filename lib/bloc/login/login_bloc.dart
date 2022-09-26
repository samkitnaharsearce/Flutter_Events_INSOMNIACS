import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:matrix/allUtilities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {

    on<ConnectEvent>((event, emit) async{
      SendEmail(event.data);
    });

    on<IsLoggedInEvent>((event, emit) async{
      String? status = await storage.read(key: "login_status");
      if (status != "true"){
        emit(const NewLogInState());
        print("NewLogInState");
      }
      else{
        String? urn = await storage.read(key: "login_urn");
        String? email = await storage.read(key: "login_email");

        String data = jsonEncode({"email":email,"linked_url":urn});

       emit(LoggedInState(qrData:data));
       print("LoggedInState");
      }
    });

    on<EndingLoginEvent>((event,emit) async{
      emit(EndingLoginState());
      Future.delayed(Duration(seconds: 2),() async{
        add(SuccessfulLoginEvent());
      });
    });

    on<SuccessfulLoginEvent>((event, emit) async{
      storage.write(key: "login_status", value: "true");
    });



  }
}
