import 'package:flutter/material.dart';

ColorScheme getColorScheme(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return colorScheme;
}