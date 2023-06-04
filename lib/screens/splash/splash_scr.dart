import 'package:ati_all_in_one/blocs/route/route_bloc.dart';
import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_routes.dart';
import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:ati_all_in_one/screens/dashboard/dashboard_scr.dart';
import 'package:ati_all_in_one/screens/auth/log_in_scr.dart';
import 'package:ati_all_in_one/utilities/get_location.dart';
import 'package:ati_all_in_one/utilities/launch_url.dart';
import 'package:ati_all_in_one/widgets/my_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RouteBloc>().add(DoRouteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RouteBloc, RouteState>(
      listener: (context, state) {
        if (state is RouteLoginState) {
          MyRoutes.pushAndRemoveUntil(context, const LogInScreen());
        } else if(state is RouteDashboardState){
          context.read<FetchAppListBloc>().add(DoFetchAppListEvent());
          MyRoutes.pushAndRemoveUntil(context, const DashboardScreen());
          determinePosition();
        } else if(state is UpdateAlertState){
          MyRoutes.pushAndRemoveUntil(context, const LogInScreen());
              state.updateIs
                  ? myAlertDialog(context, state.title, state.content,
                      actions: [
                          CupertinoButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: MyColors.uninstall),
                              ),
                              onPressed: () => Navigator.pop(context)),
                          CupertinoButton(
                              child: const Text('Go to Store'),
                              onPressed: () =>
                                  launchAppStore(MyUrls.appStoreLink)),
                        ])
                  : myAlertDialog(context, state.title, state.content);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/images/splash.png',height: MySizes.height(context)/5,),
        ),
      ),
    );
  }
}
