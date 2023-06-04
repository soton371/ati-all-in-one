import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/db/apps_hub_db.dart';
import 'package:ati_all_in_one/models/apps_hub_mod.dart';
import 'package:ati_all_in_one/screens/dashboard/components/build_item.dart';
import 'package:ati_all_in_one/utilities/responsive.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderableItems extends StatefulWidget {
  const ReorderableItems(this.getAppList, {super.key});
  final List<AppsHubModel> getAppList;

  @override
  State<ReorderableItems> createState() => _ReorderableItemsState();
}

class _ReorderableItemsState extends State<ReorderableItems> {
  @override
  Widget build(BuildContext context) {
    return ReorderableGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      //for drag design
      dragWidgetBuilder: (index, child) {
        return child;
      },
      //end drag design
      padding: const EdgeInsets.all(MySizes.bodyPadding),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: Responsive.isMobile(context)
          ? 2
          : Responsive.isTablet(context)
              ? 3
              : 4,
      children: widget.getAppList
          .map((e) => Card(
            key: ValueKey(e.appId),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: BuildItem("${e.appName}", '${e.appId}', '${e.appImg}', '${e.appUrl}', '${e.appInstalled}')))
          .toList(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final element = widget.getAppList.removeAt(oldIndex);
          widget.getAppList.insert(newIndex, element);
        });
        //for store data after new sort
          AppsHubDb.instance.deleteAllApps();
          int appOrder = 1;
          for (var data in widget.getAppList) {
            AppsHubDb.instance.addApp(AppsHubModel(
                appOrder: appOrder,
                appName: data.appName,
                appId: data.appId,
                appImg: data.appImg,
                appInstalled: data.appInstalled
                ));
            appOrder++;
          }
          //end store data after new sort
      },
    );
  }
}
