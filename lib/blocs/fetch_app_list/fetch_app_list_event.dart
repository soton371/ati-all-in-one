part of 'fetch_app_list_bloc.dart';

@immutable
abstract class FetchAppListEvent extends Equatable {
  const FetchAppListEvent();

  @override
  List<Object> get props => [];
}

class DoFetchAppListEvent extends FetchAppListEvent {}

class RefreshAppListEvent extends FetchAppListEvent {}
