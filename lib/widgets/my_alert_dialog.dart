import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:ati_all_in_one/models/checklist_model.dart';
import 'package:ati_all_in_one/widgets/my_checklist.dart';
import 'package:ati_all_in_one/widgets/my_cupertino_dropdown.dart';
import 'package:ati_all_in_one/widgets/my_radio_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> myAlertDialog(BuildContext context, String title, String content,
    {List<Widget> actions = const <Widget>[],
    bool barrierDismissible = false}) async {
  showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: content.isEmpty ? null : Text(content),
            actions: actions,
          ));
}

//for input
Future<void> myInputAlertDialog(BuildContext context) async {
  TextEditingController inputController = TextEditingController();
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('@mention'),
            content: CupertinoTextField(
              controller: inputController,
              placeholder: 'Inputs Here..',
              maxLines: 3,
              style: TextStyle(
                color: MyTheme.isDarkMode(context)
                    ? MyColors.white
                    : MyColors.black,
              ),
            ),
            actions: [
              CupertinoButton(child: const Text('Cancel'), onPressed: ()=>Navigator.pop(context)),
              CupertinoButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ));
}

//for dropdown
Future<void> myDropdownAlertDialog(BuildContext context,
    {List<String>? items}) async {
  String selectedValue = items != null && items.isNotEmpty ? items[0] : '';
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
            title: const Text('Select One'),
            content: items != null && items.isNotEmpty
                ? CupertinoDropdown(
                    items: items,
                    onChanged: (value) {
                      // Do something with the selected value
                      selectedValue = value;
                    },
                  )
                : const Text('No items are available'),
            actions: [
              CupertinoButton(child: const Text('Cancel'), onPressed: ()=>Navigator.pop(context)),
              CupertinoButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    debugPrint('Dropdown selectedValue: $selectedValue');
                    Navigator.pop(context);
                  })
            ],
          ));
}

//for radio

Future<void> myRadioAlertDialog(BuildContext context,
    {List<String>? options,
    String? selectedOption}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor:
          MyTheme.isDarkMode(context) ? MyColors.black : CupertinoColors.systemGrey6,
      title: const Text(
        'Select One',
        textAlign: TextAlign.center,
      ),
      content: options != null && options.isNotEmpty
          ? RadioGroup(
              options: options,
              selectedOption: selectedOption,
              onChanged: (p0) => selectedOption = p0,
            )
          : const Text('No options are available'),
    ),
  );
}

//for checkbox
Future<void> myCheckboxAlertDialog(BuildContext context,
    {List<ChecklistModel>? checkLists}) async {
  showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            actionsPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            backgroundColor:
                MyTheme.isDarkMode(context) ? MyColors.black : CupertinoColors.systemGrey6,
            title: const Text(
              'Check List',
              textAlign: TextAlign.center,
            ),
            content: checkLists != null && checkLists.isNotEmpty
                ? MyChecklist(
                    items: checkLists,
                  )
                : const Text('There is no checklists are available'),
          ));
}
