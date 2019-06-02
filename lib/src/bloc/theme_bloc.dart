import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/commons/scales.dart';
import 'package:todo_list/src/commons/font_family.dart';
import 'package:todo_list/src/models/app_config.dart';
import 'package:todo_list/src/utils/shared_preferences_helper.dart';

class ThemeBloc implements BlocBase {
  static final ThemeBloc _bloc = new ThemeBloc._internal();
  SharedPreferencesHelper helper = SharedPreferencesHelper();

  factory ThemeBloc() {
    return _bloc;
  }

  ThemeBloc._internal() {
  }

  DisplayConfig display = DisplayConfig.defaultConfig();

  BehaviorSubject<DisplayConfig> _displayController = BehaviorSubject<DisplayConfig>();

  Stream<DisplayConfig> get displayConfig => _displayController.stream;

  set setFontSize(TextScaleValue fontSize) {
    display.fontSize = fontSize.label;
    _displayController.add(display);
    helper.setAppConfigs(display);
  }

  set setFontFamily(FontFamily family) {
    display.fontFamily = family.label;
    _displayController.add(display);
    helper.setAppConfigs(display);
  }

  set setDisplayConfig(DisplayConfig config) {
    display = config;
    _displayController.add(display);
  }

  @override
  void initState() {}

  @override
  void dispose() {
    _displayController.close();
  }
}

ThemeBloc themeBloc = ThemeBloc();
