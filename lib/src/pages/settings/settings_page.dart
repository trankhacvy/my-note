import 'package:flutter/material.dart';
import 'package:todo_list/src/bloc/theme_bloc.dart';
import 'package:todo_list/src/commons/scales.dart';
import 'package:todo_list/src/commons/font_family.dart';
import 'package:todo_list/src/models/app_config.dart';

class SettingsScreen extends StatelessWidget {
  final GlobalKey _menuFontSizeKey = new GlobalKey();
  final GlobalKey _menuFontFamilyKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: StreamBuilder<DisplayConfig>(
        stream: themeBloc.displayConfig,
        initialData: DisplayConfig.defaultConfig(),
        builder: (context, snapshot) {
          DisplayConfig config = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text('Font Size'),
                onTap: () {
                  dynamic state = _menuFontSizeKey.currentState;
                  state.showButtonMenu();
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(config.fontSize),
                    PopupMenuButton<TextScaleValue>(
                        key: _menuFontSizeKey,
                        initialValue: getTextValueScaleByLabel(config.fontSize),
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (obj) {
                          themeBloc.setFontSize = obj;
                        },
                        itemBuilder: (context) {
                          return kAllTextScaleValues
                              .map((item) =>
                                  PopupMenuItem<TextScaleValue>(
                                    value: item,
                                    child: Text(item.label),
                                  ))
                              .toList();
                        })
                  ],
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Font family'),
                onTap: () {
                  dynamic state = _menuFontFamilyKey.currentState;
                  state.showButtonMenu();
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(config.fontFamily),
                    PopupMenuButton<FontFamily>(
                        key: _menuFontFamilyKey,
                        initialValue: getFontFamilyByLabel(config.fontFamily),
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (fontFamily) {
                          themeBloc.setFontFamily = fontFamily;
                        },
                        itemBuilder: (context) {
                          return Fonts
                              .map((font) =>
                                  PopupMenuItem<FontFamily>(
                                    value: font,
                                    child: Text(font.label, style: TextStyle(
                                      fontFamily: font.name
                                    ),),
                                  ))
                              .toList();
                        })
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}