import 'dart:async';
import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/utilities/open_apps.dart';
import 'package:ati_all_in_one/utilities/uninstall_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildItem extends StatelessWidget {
  const BuildItem(this.text, this.id, this.img, this.url, this.appInstalled,
      {super.key});
  final String text, id, img, url, appInstalled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () => openApps(id, ''),
            child: Column(
              children: [
                Flexible(child: Image.asset(img)),
                Text(
                  '\n$text',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )),

        //for uninstall button
        Positioned(
            right: 0,
            child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            uninstallApp(id, url);
                            Timer(const Duration(seconds: 6), () {
                              debugPrint('test uninstall');
                              context
                                  .read<FetchAppListBloc>()
                                  .add(RefreshAppListEvent());
                            });
                          },
                          height: 30,
                          child: const Center(child: Text('Uninstall',style: TextStyle(color: MyColors.uninstall),)))
                    ]))
      ],
    );
  }
}
