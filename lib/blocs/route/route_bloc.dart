
import 'package:ati_all_in_one/configs/my_preference_keys.dart';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:ati_all_in_one/models/app_data_mod.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(RouteInitial()) {
    on<DoRouteEvent>((event, emit) async {
      debugPrint("call DoRouteEvent");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String refreshToken =
          prefs.getString(MyPreferenceKeys.refreshToken) ?? '';
      bool rememberIs = prefs.getBool(MyPreferenceKeys.rememberIs) ?? false;
      if (refreshToken.isNotEmpty && rememberIs == true) {
        // emit(RouteDashboardState());
        Uri url = Uri.parse(MyUrls.appData);
        try {
          var response = await http.post(url).timeout(const Duration(seconds: 5));
        final appDataModel = appDataModelFromJson(response.body);
        if (appDataModel.statusCode == 200) {
          //here check update
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String appVersionCode = packageInfo.buildNumber;
          int localAppVersion = int.parse(appVersionCode);
          int userActiveFlag =
              prefs.getInt(MyPreferenceKeys.userActiveFlag) ?? 0;
          int appServerVersion = 0;
          var obj = appDataModel.objResponse;
          if (obj != null && obj.appServerVersion != null) {
            appServerVersion = obj.appServerVersion ?? 0;
            await prefs.setInt(MyPreferenceKeys.appServerVersion, appServerVersion);
          }
          debugPrint(
              'userActiveFlag: $userActiveFlag, localAppVersion: $localAppVersion, appServerVersion: $appServerVersion');
          userActiveFlag = 1;
          localAppVersion = 1;
          appServerVersion = 1;
          debugPrint(
              '>>> userActiveFlag: $userActiveFlag, localAppVersion: $localAppVersion, appServerVersion: $appServerVersion');
          
          if (userActiveFlag == 0) {
            emit(const UpdateAlertState(
                'Account Locked!!',
                'Your Account is Locked. Please Contact With Your Service Provider',
                false));
          } else if (localAppVersion < appServerVersion) {
            emit(const UpdateAlertState(
                'New version available!',
                'Highly recommended to update App for better experience.',
                true));
          } else if (localAppVersion > appServerVersion) {
            emit(const UpdateAlertState('Maintenance Break!!',
                'We working on server for new version. please wait..', false));
          } else if (userActiveFlag != 0 &&
              localAppVersion == appServerVersion) {
            emit(RouteDashboardState());
          }
        } else {
          //get app data something wrong
          // emit(UpdateAlertState('${appDataModel.statusCode}',
          //       '${appDataModel.message}', false));
          emit(RouteDashboardState());
        }
        } catch (e) {
          emit(RouteDashboardState());
        }
        
      } else {
        emit(RouteLoginState());
      }
    });
  }
}
