import 'package:flutter/material.dart';
/*
DropdownPicker(
                menuOptions: list of dropdown options in key value pairs,
                selectedOption: menu option string value,
                onChanged: (value) => print('changed'),
              ),
*/

class DropdownPicker extends StatelessWidget {
  DropdownPicker({
    required this.menuOptions,
    required this.selectedOption,
    required this.onChanged,
    this.isExpanded = false,
    this.marginButtom = 15,
    this.marginTop = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
  });

  final List<dynamic> menuOptions;
  final String selectedOption;
  final void Function(String?) onChanged;
  final bool isExpanded;
  final double marginButtom;
  final double marginTop;
  final double marginLeft;
  final double marginRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          width: 0.2,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 15),
      margin: EdgeInsets.only(
        bottom: marginButtom,
        top: marginTop,
        left: marginLeft,
        right: marginRight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(Icons.group),
          SizedBox(width: 10),
          SizedBox(
            height: 45,
            child: DropdownButton<String>(
              items: menuOptions
                  .map((data) => DropdownMenuItem<String>(
                        child: Text(
                          data.value,
                        ),
                        value: data.key,
                      ))
                  .toList(),
              value: selectedOption,
              onChanged: onChanged,
              isExpanded: isExpanded,
            ),
          ),
        ],
      ),
    );
  }
}
