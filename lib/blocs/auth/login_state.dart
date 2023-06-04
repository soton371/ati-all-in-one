part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {
  final String msgT, msgC;
  const LoginFailedState(this.msgT, this.msgC);
  @override
  List<Object?> get props => [msgT, msgC];
}

class InternetExceptionState extends LoginState {
  final String msgT, msgC;
  const InternetExceptionState(this.msgT, this.msgC);
  @override
  List<Object?> get props => [msgT, msgC];
}

class TimeoutExceptionState extends LoginState {
  final String msgT, msgC;
  const TimeoutExceptionState(this.msgT, this.msgC);
  @override
  List<Object?> get props => [msgT, msgC];
}

class RecommendedAlertState extends LoginState {
  final String title, content;
  final bool updateIs;
  const RecommendedAlertState(this.title, this.content, this.updateIs);
}

class NoNeedAlertState extends LoginState {}
