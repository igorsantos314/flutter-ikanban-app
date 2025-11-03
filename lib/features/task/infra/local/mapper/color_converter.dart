import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class ColorConverter extends TypeConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromSql(String fromDb) {
    try {
      final hexString = fromDb.replaceAll('#', '').trim();
      
      if (!RegExp(r'^[0-9A-Fa-f]{6,8}$').hasMatch(hexString)) {
        return Colors.grey;
      }
      
      final paddedHex = hexString.padLeft(8, 'F');
      return Color(int.parse('0x$paddedHex'));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  String toSql(Color value) {
    return value.toHex();
  }
}

extension ColorExtension on Color {
  String toHex() {
    return value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  String toHexWithHash() {
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}