part of 'fetch_app_list_bloc.dart';

@immutable
abstract class FetchAppListState extends Equatable {
  const FetchAppListState();
  @override
  List<Object> get props => [];
}

class FetchAppListInitial extends FetchAppListState {}

class FetchAppListLoadingState extends FetchAppListState {
  final List<AppsHubModel> appList, installedAppList, notInstalledAppList;
  const FetchAppListLoadingState(
      this.appList, this.installedAppList, this.notInstalledAppList);
  @override
  List<Object> get props => [appList, installedAppList, notInstalledAppList];
}

class FetchAppListFetchedState extends FetchAppListState {
  final List<AppsHubModel> appList, installedAppList, notInstalledAppList;
  const FetchAppListFetchedState(
      this.appList, this.installedAppList, this.notInstalledAppList);
  @override
  List<Object> get props => [appList, installedAppList, notInstalledAppList];
}

class FetchAppListFailedState extends FetchAppListState {}

