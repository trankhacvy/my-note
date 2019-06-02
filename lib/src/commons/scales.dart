import 'package:flutter/material.dart';

class TextScaleValue {
  const TextScaleValue(this.scale, this.label);

  final double scale;
  final String label;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final TextScaleValue typedOther = other;
    return scale == typedOther.scale && label == typedOther.label;
  }

  @override
  int get hashCode => hashValues(scale, label);

  @override
  String toString() {
    return '$runtimeType($label)';
  }

}

const List<TextScaleValue> kAllTextScaleValues = <TextScaleValue>[
  TextScaleValue(null, 'System Default'),
  TextScaleValue(0.8, 'Small'),
  TextScaleValue(1.0, 'Normal'),
  TextScaleValue(1.3, 'Large'),
  TextScaleValue(2.0, 'Huge'),
];

TextScaleValue getTextValueScaleByLabel(String label){
  List<TextScaleValue> results = kAllTextScaleValues.where((value) =>value.label == label).toList();
  return results.length > 0 ? results[0] : kAllTextScaleValues[0];
}