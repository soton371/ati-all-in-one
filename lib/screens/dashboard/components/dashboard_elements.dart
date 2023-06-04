import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/screens/dashboard/components/not_install_items.dart';
import 'package:ati_all_in_one/screens/dashboard/components/reorderable_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class DashboardElements extends StatefulWidget {
  const DashboardElements({super.key});

  @override
  State<DashboardElements> createState() => _DashboardElementsState();
}

class _DashboardElementsState extends State<DashboardElements> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAppListBloc, FetchAppListState>(
        builder: (context, state) {
      if (state is FetchAppListLoadingState) {
        return state.appList.isEmpty
            ? Center(
                child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MySizes.width(context) / 2),
                child: const LinearProgressIndicator(),
              ))
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  state.installedAppList.isNotEmpty
                      ? ReorderableItems(state.installedAppList)
                      : const SizedBox(),
                  state.notInstalledAppList.isNotEmpty
                      ? NotInstallItems(state.notInstalledAppList)
                      : const SizedBox(),
                ],
              );
      } else if (state is FetchAppListFailedState) {
        return Center(
            child: Lottie.asset('assets/lottiefiles/something-went-wrong.zip',
                height: MySizes.height(context) / 2));
      } else if (state is FetchAppListFetchedState) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            state.installedAppList.isNotEmpty
                ? ReorderableItems(state.installedAppList)
                : const SizedBox(),
            state.notInstalledAppList.isNotEmpty
                ? NotInstallItems(state.notInstalledAppList)
                : const SizedBox(),
          ],
        );
      }
      return Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MySizes.width(context) / 2),
        child: const LinearProgressIndicator(),
      ));
    });
  }
}
