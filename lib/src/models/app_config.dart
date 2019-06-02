class DisplayConfig {
  String fontSize;
  String fontFamily;

  DisplayConfig.defaultConfig(){
    fontSize = 'System Default';
    fontFamily = 'System Default';
  }

  DisplayConfig.fromJson(Map<String, dynamic> data){
    fontSize = data['fontSize'];
    fontFamily = data['fontFamily'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'fontFamily': fontFamily,
    };
  }

}