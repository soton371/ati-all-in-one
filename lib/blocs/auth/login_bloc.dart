import 'dart:async';
import 'dart:io';

import 'package:ati_all_in_one/configs/my_preference_keys.dart';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:ati_all_in_one/models/login_mod.dart';
import 'package:ati_all_in_one/utilities/get_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String msgT = '';
  String msgC = '';
  LoginBloc() : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      debugPrint('call DoLoginEvent');
      emit(LoginLoadingState());
      final prefs = await SharedPreferences.getInstance();
      //for appVersionCode
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersionCode = packageInfo.buildNumber;
      int localAppVersion = int.parse(appVersionCode);
      //end appVersionCode

      //for app data info get
      int appServerVersion = prefs.getInt(MyPreferenceKeys.appServerVersion) ?? 0;
      int userActiveFlag = prefs.getInt(MyPreferenceKeys.userActiveFlag) ?? 0; //wanna login hit
      //end app data info get

      Uri url =
          Uri.parse(MyUrls.appLogin(event.email.trim(), event.password.trim()));
      debugPrint('url: $url');
      try {
        var response =
            await http.post(url).timeout(const Duration(seconds: 60));
        //for 200 check
        if (response.statusCode == 200) {
          final loginModel = loginModelFromJson(response.body);
          emit(LoginSuccessState());
          determinePosition();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              MyPreferenceKeys.accessToken, loginModel.accessToken ?? '');
          await prefs.setString(
              MyPreferenceKeys.refreshToken, loginModel.refreshToken ?? '');
          await prefs.setBool(MyPreferenceKeys.rememberIs, event.rememberIs);
          //for update alert
          debugPrint('userActiveFlag: $userActiveFlag, localAppVersion: $localAppVersion, appServerVersion: $appServerVersion');
          userActiveFlag = 1;
          localAppVersion = 1;
          appServerVersion = 1;
          debugPrint(
              '>>> userActiveFlag: $userActiveFlag, localAppVersion: $localAppVersion, appServerVersion: $appServerVersion');
          
          if (userActiveFlag == 0) {
                emit(const RecommendedAlertState('Account Locked!!',
                    'Your Account is Locked. Please Contact With Your Service Provider',false));
              } else if (localAppVersion < appServerVersion) {
                emit(const RecommendedAlertState('New version available!',
                    'Highly recommended to update App for better experience.',true));
              } else if (localAppVersion > appServerVersion) {
                emit(const RecommendedAlertState('Maintenance Break!!',
                    'We working on server for new version. please wait..',false));
              } else if (userActiveFlag != 0 &&
                  localAppVersion == appServerVersion) {
                emit(NoNeedAlertState());
              }
          //end update alert
        } else {
          debugPrint(
              'DoLoginEvent response.statusCode: ${response.statusCode}');
          msgT = 'Wrong Credentials';
          msgC = 'Invalid username or password';
          emit(LoginFailedState(msgT, msgC));
        }
      } on TimeoutException catch (e) {
        debugPrint('DoLoginEvent TimeoutException: $e');
        msgT = 'Timeout';
        msgC = 'Please try again';
        emit(TimeoutExceptionState(msgT, msgC));
      } on SocketException catch (e) {
        debugPrint('DoLoginEvent SocketException: $e');
        msgT = 'Connection Failed';
        msgC = 'Check your internet connection';
        emit(InternetExceptionState(msgT, msgC));
      } catch (e) {
        debugPrint('DoLoginEvent e: $e');
        msgT = 'Something Wrong';
        msgC = 'An error occurred while logging in';
        emit(LoginFailedState(msgT, msgC));
      }
    });

    //for logout
    on<DoLogoutEvent>((event, emit) async {
      debugPrint('call on<DoLogoutEvent>');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(MyPreferenceKeys.accessToken);
      await prefs.remove(MyPreferenceKeys.rememberIs);
    });
  }
}
