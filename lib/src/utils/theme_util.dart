import 'package:flutter/material.dart';
import 'package:todo_list/src/commons/font_family.dart';
import 'package:todo_list/src/models/app_config.dart';

ThemeData buildTheme(DisplayConfig config) {
   return ThemeData.light().copyWith(
     primaryColor: Colors.green,
          accentColor: Colors.red,
          textTheme: ThemeData.light().textTheme.apply(fontFamily: getFontFamilyByLabel(config.fontFamily).name)
   );
}
