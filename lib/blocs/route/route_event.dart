part of 'route_bloc.dart';

@immutable
abstract class RouteEvent extends Equatable{
  const RouteEvent();
  @override
  List<Object> get props => [];
}

class DoRouteEvent extends RouteEvent {
  
}
