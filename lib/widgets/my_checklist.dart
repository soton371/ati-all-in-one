
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:ati_all_in_one/models/checklist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyChecklist extends StatefulWidget {
  final List<ChecklistModel>? items;
  const MyChecklist({super.key, this.items});

  @override
  State<MyChecklist> createState() => _MyChecklistState();
}

class _MyChecklistState extends State<MyChecklist> {
  List<ChecklistModel> checkLists = [];
  @override
  void initState() {
    super.initState();
    checkLists = widget.items ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var element in checkLists)
          CheckboxListTile(
            value: element.value,
            onChanged: (v) {
              setState(() {
                element.value = v;
              });
            },
            title: Text(element.title ?? ''),
            activeColor: MyTheme.activeColor(context),
            checkboxShape: const StadiumBorder(),
          ),

        //for action button
        Divider(
            height: 0,
            color: MyTheme.isDarkMode(context)
                ? const Color.fromARGB(255, 76, 76, 78)
                : CupertinoColors.separator),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(child: const Text('Cancel'), onPressed: ()=>Navigator.pop(context)),

            Container(color:  MyTheme.isDarkMode(context)
                ? const Color.fromARGB(255, 76, 76, 78)
                : CupertinoColors.separator,width: 0.5,height: 50,),
            

            CupertinoButton(
                child: const Text('Submit'),
                onPressed: () {
                  var value = checkLists.map((e) {
                    if (e.value == true) {
                      return e.title;
                    }else{
                      return '';
                    }
                  });
                  debugPrint("Checklist submit: $value");
                  Navigator.pop(context);
                }),
          ],
        ),
      ],
    );
  }
}
