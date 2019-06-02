int hexToColor(String code) {
  return int.parse(code.substring(1, 7), radix: 16) + 0xFF000000;
}