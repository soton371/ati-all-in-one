import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:flutter/cupertino.dart';

class CupertinoDropdown extends StatefulWidget {
  final List<String>? items;
  final ValueChanged<String>? onChanged;

  const CupertinoDropdown({
    Key? key,
    this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  CupertinoDropdownState createState() => CupertinoDropdownState();
}

class CupertinoDropdownState extends State<CupertinoDropdown> {
  int _selectedIndex = 0;
  List<String> item = [];
  @override
  void initState() {
    super.initState();
    item = widget.items ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = 0;
        });
        _showPicker();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: CupertinoColors.systemGrey2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text(item[_selectedIndex])),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MySizes.height(context) / 5,
          child: CupertinoPicker(
            backgroundColor: MyTheme.isDarkMode(context)
                ? CupertinoColors.black
                : CupertinoColors.white,
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              var valueChanged = widget.onChanged;
              if (valueChanged != null) {
                valueChanged(item[_selectedIndex]);
              }
            },
            children: List<Widget>.generate(item.length, (int index) {
              return Center(
                child: Text(item[index]),
              );
            }),
          ),
        );
      },
    );
  }
}
