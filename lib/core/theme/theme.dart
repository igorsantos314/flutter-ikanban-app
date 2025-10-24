import 'package:flutter/material.dart';
  
// Light Theme Colors
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1E88E5), // Azul forte
  onPrimary: Color(0xFFFFFFFF), // Branco para contraste
  primaryContainer: Color(0xFFBBDEFB), // Azul claro para fundo
  onPrimaryContainer: Color(0xFF0D47A1), // Azul escuro

  secondary: Color(0xFF424242), // Cinza escuro
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFBDBDBD),
  onSecondaryContainer: Color(0xFF212121),

  tertiary: Color(0xFF4CAF50), // Verde acento
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC8E6C9),
  onTertiaryContainer: Color(0xFF1B5E20),

  error: Color(0xFFD32F2F), // Vermelho para alertas
  errorContainer: Color(0xFFFFCDD2),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFB71C1C),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF212121),
  surfaceContainerHighest: Color(0xFFEEEEEE),
  onSurfaceVariant: Color(0xFF757575),

  outline: Color(0xFFBDBDBD),
  inverseSurface: Color(0xFF37474F),
  inversePrimary: Color(0xFF90CAF9),
  surfaceTint: Color(0xFF1E88E5),
  outlineVariant: Color(0xFF9E9E9E),
  scrim: Color(0xFF000000),
);

// Dark Theme Colors
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF90CAF9), // Azul claro
  onPrimary: Color(0xFF0D47A1),
  primaryContainer: Color(0xFF1E88E5),
  onPrimaryContainer: Color(0xFFBBDEFB),

  secondary: Color(0xFFBDBDBD), // Cinza mÃ©dio
  onSecondary: Color(0xFF424242),
  secondaryContainer: Color(0xFF757575),
  onSecondaryContainer: Color(0xFFE0E0E0),

  tertiary: Color(0xFF81C784), // Verde mais suave
  onTertiary: Color(0xFF1B5E20),
  tertiaryContainer: Color(0xFF388E3C),
  onTertiaryContainer: Color(0xFFC8E6C9),

  error: Color(0xFFFF5252),
  errorContainer: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFB71C1C),

  surface: Color(0xFF37474F),
  onSurface: Color(0xFFECEFF1),
  surfaceContainerHighest: Color(0xFF455A64),
  onSurfaceVariant: Color(0xFFB0BEC5),

  outline: Color(0xFF78909C),
  inverseSurface: Color(0xFFECEFF1),
  inversePrimary: Color(0xFF1E88E5),
  surfaceTint: Color(0xFF90CAF9),
  outlineVariant: Color(0xFF546E7A),
  scrim: Color(0xFF000000),
);

// Aplica a paleta de cores ao ThemeData
final ThemeData lightTheme = ThemeData.from(
  colorScheme: lightColorScheme,
  useMaterial3: true, // Material You (Opcional)
).copyWith(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E88E5), // Azul forte
    foregroundColor: Colors.white, // Ícones brancos
  ),
  scaffoldBackgroundColor: lightColorScheme.surface, // Fundo claro
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF1E88E5), // Azul para botões
  ),
);

final ThemeData darkTheme = ThemeData.from(
  colorScheme: darkColorScheme,
  useMaterial3: true, // Material You (Opcional)
).copyWith(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D47A1), // Azul escuro
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: darkColorScheme.surface, // Fundo escuro
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF90CAF9), // Azul mais claro para botões
  ),
);
