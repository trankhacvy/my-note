import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/src/models/app_config.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  final String _appConfigPrefs = "app_configs";

  Future<bool> setAppConfigs(DisplayConfig config) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map configsMap = config.toMap();
    String configsString = json.encode(configsMap);
    return prefs.setString(_appConfigPrefs, configsString);
  }

  Future<DisplayConfig> getAppConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String configsString = prefs.getString(_appConfigPrefs);
    if(configsString != null) {
      Map configsMap = json.decode(configsString);
      return DisplayConfig.fromJson(configsMap);
    }
    return DisplayConfig.defaultConfig();
  }
}
