
enum THEME {
  DARK, LIGHT
}

class AppTheme {
  final THEME theme;
  final String label;

  const AppTheme(this.theme, this.label);
}

const List<AppTheme> Themes = <AppTheme>[AppTheme(THEME.LIGHT, 'Light'), AppTheme(THEME.DARK, 'Dark')];