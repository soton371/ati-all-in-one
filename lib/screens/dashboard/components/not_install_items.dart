import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:ati_all_in_one/models/apps_hub_mod.dart';
import 'package:ati_all_in_one/utilities/open_apps.dart';
import 'package:ati_all_in_one/utilities/responsive.dart';
import 'package:flutter/material.dart';

class NotInstallItems extends StatelessWidget {
  const NotInstallItems(this.getNotInstallAppList, {super.key});
  final List<AppsHubModel> getNotInstallAppList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: MySizes.bodyPadding),
              height: 20,
              width: 10,
              decoration: BoxDecoration(
                color: MyTheme.isDarkMode(context) ? MyColors.white : MyColors.black,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(5))
              ),
            ),
            const Text(' The apps below are not installed on your device',maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(MySizes.bodyPadding),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
                  ? 3
                  : 4,
          children: getNotInstallAppList
              .map((e) => Card(
                  key: ValueKey(e.appId),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Flexible(child: Image.asset(e.appImg ?? '')),
                            Text(
                              '\n${e.appName}',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                      //add for download
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyTheme.isDarkMode(context)? Colors.black38 : Colors.white60),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            openApps(e.appId ?? '', e.appUrl ?? '');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  color:Colors.black45,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.download, color: Colors.white),
                                  Text(
                                    ' Download',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  )))
              .toList(),
        ),
      ],
    );
  }
}
