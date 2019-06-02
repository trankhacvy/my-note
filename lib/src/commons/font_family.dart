class FontFamily {
  final String name;
  final String label;

  const FontFamily(this.name, this.label);
}

const Fonts = [
  FontFamily(null, 'System Default'),
  FontFamily('DancingScript', 'Dancing Script'),
  FontFamily('Gabriela', 'Gabriela'),
  FontFamily('Neuton', 'Neuton'),
  FontFamily('PlayfairDisplay', 'Playfair Display')
];

FontFamily getFontFamilyByLabel(String label){
  List<FontFamily> results = Fonts.where((value) =>value.label == label).toList();
  return results.length > 0 ? results[0] : Fonts[0];
}