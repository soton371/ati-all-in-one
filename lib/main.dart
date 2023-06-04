import 'package:ati_all_in_one/blocs/get_image/get_image_bloc.dart';
import 'package:ati_all_in_one/blocs/route/route_bloc.dart';
import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/blocs/auth/login_bloc.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:ati_all_in_one/screens/splash/splash_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchAppListBloc>(
          create: (BuildContext context) => FetchAppListBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<RouteBloc>(
          create: (BuildContext context) => RouteBloc(),
        ),
        BlocProvider<GetImageBloc>(
          create: (BuildContext context) => GetImageBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'ATI All In One',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: MyTheme
            .lightTheme, // applies this theme if the device theme is light mode
        darkTheme: MyTheme
            .darkTheme, // applies this theme if the device theme is dark mode
        home: const SplashScreen(),
      ),
    );
  }
}
