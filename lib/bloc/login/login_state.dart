part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends Equatable implements LoginState{
  final String qrData;

  const LoggedInState({required this.qrData});

  @override
  // TODO: implement props
  List<Object?> get props => [qrData];
}


class NewLogInState extends Equatable implements LoginState{
  const NewLogInState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EndingLoginState extends Equatable implements LoginState {
  const EndingLoginState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ShowAppLinkQrState implements LoginState{
  final String appLink;

  const ShowAppLinkQrState({required this.appLink});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}

