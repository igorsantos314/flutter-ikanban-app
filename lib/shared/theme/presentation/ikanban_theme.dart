import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF3D5AFE);
const Color secondaryGreen = Color(0xFF00C853);
const Color tertiaryYellow = Color(0xFFFFC107);
const Color errorRed = Color(0xFFFF3D00);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryBlue,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE8EAF6),
  onPrimaryContainer: Color(0xFF1A237E),

  secondary: secondaryGreen,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFC8E6C9),
  onSecondaryContainer: Color(0xFF1B5E20),

  tertiary: tertiaryYellow,
  onTertiary: Color(0xFF212121),
  tertiaryContainer: Color(0xFFFFECB3),
  onTertiaryContainer: Color(0xFFFF6F00),

  error: errorRed,
  errorContainer: Color(0xFFFFD1C4),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFB71C1C),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF212121),
  surfaceContainerHighest: Color(0xFFF5F5F5),
  onSurfaceVariant: Color(0xFF757575),

  outline: Color(0xFFBDBDBD),
  inverseSurface: Color(0xFF424242),
  inversePrimary: Color(0xFFAAB6FE),
  surfaceTint: primaryBlue,
  outlineVariant: Color(0xFF9E9E9E),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFAAB6FE),
  onPrimary: Color(0xFF1A237E),
  primaryContainer: Color(0xFF303F9F),
  onPrimaryContainer: Color(0xFFE8EAF6),

  secondary: Color(0xFF81C784),
  onSecondary: Color(0xFF2E7D32),
  secondaryContainer: Color(0xFF388E3C),
  onSecondaryContainer: Color(0xFFC8E6C9),

  tertiary: Color(0xFFFFD54F),
  onTertiary: Color(0xFF757575),
  tertiaryContainer: Color(0xFFFFA000),
  onTertiaryContainer: Color(0xFFFFECB3),

  error: Color(0xFFFF8A65),
  errorContainer: Color(0xFFD84315),
  onError: Color(0xFF000000),
  onErrorContainer: Color(0xFFFFD1C4),

  surface: Color(0xFF1E1E1E),
  onSurface: Color(0xFFE0E0E0),
  surfaceContainerHighest: Color(0xFF333333),
  onSurfaceVariant: Color(0xFFB0BEC5),

  outline: Color(0xFF757575),
  inverseSurface: Color(0xFFF5F5F5),
  inversePrimary: primaryBlue,
  surfaceTint: Color(0xFFAAB6FE),
  outlineVariant: Color(0xFF546E7A),
  scrim: Color(0xFF000000),
);

final ThemeData ikanbanLightTheme =
    ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryGreen,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor: Colors.transparent,
      ),
    );

final ThemeData ikanbanDarkTheme =
    ThemeData.from(colorScheme: darkColorScheme, useMaterial3: true).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF81C784),
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: darkColorScheme.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
      ),
    );
