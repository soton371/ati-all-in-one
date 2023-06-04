part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class DoLoginEvent extends LoginEvent {
  final String email,password;
  final bool rememberIs;
  const DoLoginEvent(this.email,this.password,this.rememberIs);
  @override
  List<Object> get props => [email,password,rememberIs];
}

class DoLogoutEvent extends LoginEvent {
  
}