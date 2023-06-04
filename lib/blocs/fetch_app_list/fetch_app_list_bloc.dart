import 'dart:convert';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:ati_all_in_one/db/apps_hub_db.dart';
import 'package:ati_all_in_one/models/apps_hub_mod.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
part 'fetch_app_list_event.dart';
part 'fetch_app_list_state.dart';

class FetchAppListBloc extends Bloc<FetchAppListEvent, FetchAppListState> {
  List<AppsHubModel> appList = [];
  List<AppsHubModel> installedAppList = [];
  List<AppsHubModel> notInstalledAppList = [];
  // String msg = '';

  FetchAppListBloc() : super(FetchAppListInitial()) {
    on<DoFetchAppListEvent>((event, emit) async {
      debugPrint('call on<DoFetchAppListEvent>');
      emit(FetchAppListLoadingState(
          appList, installedAppList, notInstalledAppList));
      List<AppsHubModel> localData = await AppsHubDb.instance.getApps();
      List<AppsHubModel> iApp = [];
      List<AppsHubModel> uApp = [];
      for (var element in localData) {
        if (element.appInstalled == 'true') {
          iApp.add(element);
        } else if (element.appInstalled == 'false') {
          uApp.add(element);
        }
      }
      installedAppList = iApp;
      notInstalledAppList = uApp;
      emit(FetchAppListFetchedState(
          appList, installedAppList, notInstalledAppList));
      try {
        Uri url = Uri.parse(MyUrls.appList);

        var response = await http.get(url);
        //status 200
        if (response.statusCode == 200) {
          List responseBody = json.decode(response.body);
          //when local data empty & local < responseBody
          if (localData.length != responseBody.length) {
            debugPrint('localData.length != responseBody.length is true');
            await AppsHubDb.instance.deleteAllApps();
            int i = 0;
            for (var element in responseBody) {
              bool isInstalled = await LaunchApp.isAppInstalled(
                  androidPackageName: element['appId']);

              await AppsHubDb.instance.addApp(
                AppsHubModel(
                    appOrder: element['appOrder'],
                    appName: element['name'],
                    appId: element['appId'],
                    appImg: element['img'],
                    appUrl: element['url'],
                    appInstalled: '$isInstalled'),
              );
              i++;
              if (i == responseBody.length) {
                appList = await AppsHubDb.instance.getApps();
                List<AppsHubModel> iApp = [];
                List<AppsHubModel> uApp = [];
                for (var element in appList) {
                  if (element.appInstalled == 'true') {
                    iApp.add(element);
                  } else if (element.appInstalled == 'false') {
                    uApp.add(element);
                  }
                }
                installedAppList = iApp;
                notInstalledAppList = uApp;
                emit(FetchAppListFetchedState(
                    appList, installedAppList, notInstalledAppList));
              }
            }
            //end local data empty & local < services lis
          } else {
            debugPrint('localData.length != responseBody.length is false');
            int i = 0;
            for (var element in localData) {
              bool isInstalled = await LaunchApp.isAppInstalled(
                  androidPackageName: element.appId);

              if (isInstalled.toString() != element.appInstalled) {
                await AppsHubDb.instance
                    .updateApp(element.appOrder, '$isInstalled');
              }
              i++;
              if (i == localData.length) {
                appList = await AppsHubDb.instance.getApps();
                List<AppsHubModel> iApp = [];
                List<AppsHubModel> uApp = [];
                for (var element in appList) {
                  if (element.appInstalled == 'true') {
                    iApp.add(element);
                  } else if (element.appInstalled == 'false') {
                    uApp.add(element);
                  }
                }
                installedAppList = iApp;
                notInstalledAppList = uApp;
                emit(FetchAppListFetchedState(
                    appList, installedAppList, notInstalledAppList));
              }
            }
          }

          //end status 200
        } else {
          //start 404, 500
          debugPrint(
              'bloc DoFetchAppListEvent response.statusCode: ${response.statusCode}');

          int i = 0;
          for (var element in localData) {
            bool isInstalled = await LaunchApp.isAppInstalled(
                androidPackageName: element.appId);

            if (isInstalled.toString() != element.appInstalled) {
              await AppsHubDb.instance
                  .updateApp(element.appOrder, '$isInstalled');
            }
            i++;
            if (i == localData.length) {
              appList = await AppsHubDb.instance.getApps();
              if (appList.isEmpty) {
                emit(FetchAppListFailedState());
              } else {
                List<AppsHubModel> iApp = [];
                List<AppsHubModel> uApp = [];
                for (var element in appList) {
                  if (element.appInstalled == 'true') {
                    iApp.add(element);
                  } else if (element.appInstalled == 'false') {
                    uApp.add(element);
                  }
                }
                installedAppList = iApp;
                notInstalledAppList = uApp;
                emit(FetchAppListFetchedState(
                    appList, installedAppList, notInstalledAppList));
              }
            }
          }
          if (appList.isEmpty) {
            emit(FetchAppListFailedState());
          }
        }
      } catch (e) {
        debugPrint('bloc DoFetchAppListEvent e: $e');
        int i = 0;
        for (var element in localData) {
          bool isInstalled =
              await LaunchApp.isAppInstalled(androidPackageName: element.appId);

          if (isInstalled.toString() != element.appInstalled) {
            await AppsHubDb.instance
                .updateApp(element.appOrder, '$isInstalled');
          }
          i++;
          if (i == localData.length) {
            appList = await AppsHubDb.instance.getApps();
            if (appList.isEmpty) {
              emit(FetchAppListFailedState());
            } else {
              List<AppsHubModel> iApp = [];
              List<AppsHubModel> uApp = [];
              for (var element in appList) {
                if (element.appInstalled == 'true') {
                  iApp.add(element);
                } else if (element.appInstalled == 'false') {
                  uApp.add(element);
                }
              }
              installedAppList = iApp;
              notInstalledAppList = uApp;
              emit(FetchAppListFetchedState(
                  appList, installedAppList, notInstalledAppList));
            }
          }
        }
        if (appList.isEmpty) {
          emit(FetchAppListFailedState());
        }
      }
    });

    //for refresh data
    on<RefreshAppListEvent>((event, emit) async {
      debugPrint('call RefreshAppListEvent');
      List<AppsHubModel> localData = await AppsHubDb.instance.getApps();
      int i = 0;
      for (var element in localData) {
        bool isInstalled =
            await LaunchApp.isAppInstalled(androidPackageName: element.appId);

        if (isInstalled.toString() != element.appInstalled) {
          await AppsHubDb.instance.updateApp(element.appOrder, '$isInstalled');
        }
        i++;
        if (i == localData.length) {
          appList = await AppsHubDb.instance.getApps();

          if (appList.isEmpty) {
            emit(FetchAppListFailedState());
          } else {
            List<AppsHubModel> iApp = [];
            List<AppsHubModel> uApp = [];
            for (var element in appList) {
              if (element.appInstalled == 'true') {
                iApp.add(element);
              } else if (element.appInstalled == 'false') {
                uApp.add(element);
              }
            }
            installedAppList = iApp;
            notInstalledAppList = uApp;
            emit(FetchAppListFetchedState(
                appList, installedAppList, notInstalledAppList));
          }
        }
      }
    });
  }
}
