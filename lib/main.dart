import 'package:flutter/material.dart';
import 'package:todo_list/src/models/app_config.dart';
import 'package:todo_list/src/utils/shared_preferences_helper.dart';
import 'src/app.dart';

void main()async{

  SharedPreferencesHelper helper = SharedPreferencesHelper();
  DisplayConfig config = await helper.getAppConfigs();

  runApp(App(displayConfig: config));
}