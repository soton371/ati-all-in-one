import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/screens/dashboard/components/dashboard_elements.dart';
import 'package:ati_all_in_one/utilities/open_apps.dart';
import 'package:ati_all_in_one/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  @override
  void dispose() {
    unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<FetchAppListBloc>().add(RefreshAppListEvent());
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: const MyDrawer(),
      body: const DashboardElements(),
    );
  }
}
