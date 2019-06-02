import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:todo_list/src/commons/constants.dart';

class ColorPalette extends StatelessWidget {
  ColorPalette({this.selectedColor, this.onSelectColor});

  final Function(int) onSelectColor;
  final int selectedColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 88.0,
        margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: Platform.isAndroid ? 8 : 0),
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                  indent: 8.0,
                ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) => ColorItem(
                onTap: onSelectColor,
                isSelected: selectedColor == NOTE_COLORS[index],
                color: NOTE_COLORS[index]),
            itemCount: NOTE_COLORS.length),
      ),
    );
  }
}

class ColorItem extends StatelessWidget {
  final Function onTap;
  final bool isSelected;
  final int color;

  ColorItem({this.onTap, this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(color);
      },
      child: Container(
        width: 80.0,
        height: 80.0,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: isSelected
              ? Border.all(color: Colors.red)
              : Border.all(color: Colors.transparent),
          color: Color(color),
        ),
      ),
    );
  }
}
