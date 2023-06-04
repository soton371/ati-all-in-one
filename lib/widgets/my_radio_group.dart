import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final List<String>? options;
  final String? selectedOption;
  final Function(String)? onChanged;

  const RadioGroup(
      {super.key, this.options, this.selectedOption, this.onChanged});

  @override
  RadioGroupState createState() => RadioGroupState();
}

class RadioGroupState extends State<RadioGroup> {
  String? _selectedOption;
  List<String> myOptions = [];
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myOptions = widget.options ?? [];
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var element in myOptions)
            Row(
              children: [
                Radio<String>(
                  activeColor: MyTheme.activeColor(context),
                  value: element,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                    var valueChanged = widget.onChanged;
                    if (valueChanged != null) {
                      valueChanged(value ?? element);
                    }
                  },
                ),
                Text(element),
              ],
            ),

          _selectedOption == "B"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: inputController,
                    placeholder: 'Inputs Here..',
                    maxLines: 3,
                    style: TextStyle(
                      color: MyTheme.isDarkMode(context)
                          ? MyColors.white
                          : MyColors.black,
                    ),
                  ),
                )
              : const SizedBox(),

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
                    debugPrint('Radio _selectedOption: $_selectedOption');
                    debugPrint('Radio inputController: ${inputController.text}');
                    Navigator.pop(context);
                  }),
            ],
          ),
        ]);
  }
}


/*
children: myOptions.map((option) {
        return Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                var valueChanged = widget.onChanged;
                if (valueChanged != null) {
                  valueChanged(value ?? option);
                }
              },
            ),
            Text(option),
          ],
        );
      }).toList(),
*/
