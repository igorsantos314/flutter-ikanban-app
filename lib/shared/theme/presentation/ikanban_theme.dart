import 'package:flutter/material.dart';

// Paleta de Cores baseada nos Post-its (Vibrante e Moderna)

// Cores Chave:
const Color primaryBlue = Color(0xFF3D5AFE); // Azul Vibrante (Foco, Brand)
const Color secondaryGreen = Color(0xFF00C853); // Verde Vibrante (Ação)
const Color tertiaryYellow = Color(
  0xFFFFC107,
); // Amarelo (Acento, Média Prioridade)
const Color errorRed = Color(0xFFFF3D00); // Vermelho/Laranja (Urgente, Erro)

// Light Theme Colors
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryBlue, // Azul forte (ikanban)
  onPrimary: Color(0xFFFFFFFF), // Branco
  primaryContainer: Color(
    0xFFE8EAF6,
  ), // Azul claro (Fundo de elementos primários)
  onPrimaryContainer: Color(0xFF1A237E),

  secondary: secondaryGreen, // Verde forte (Ações)
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFC8E6C9), // Verde claro
  onSecondaryContainer: Color(0xFF1B5E20),

  tertiary: tertiaryYellow, // Amarelo/Âmbar (Prioridade Média)
  onTertiary: Color(0xFF212121), // Preto para bom contraste
  tertiaryContainer: Color(0xFFFFECB3), // Amarelo claro
  onTertiaryContainer: Color(0xFFFF6F00),

  error: errorRed, // Vermelho/Laranja forte (Prioridade Alta/Urgente)
  errorContainer: Color(0xFFFFD1C4),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFB71C1C),

  surface: Color(0xFFFFFFFF), // Fundo principal branco
  onSurface: Color(0xFF212121), // Texto escuro
  surfaceContainerHighest: Color(0xFFF5F5F5), // Cor de cards ou divisões
  onSurfaceVariant: Color(0xFF757575),

  outline: Color(0xFFBDBDBD), // Linhas de contorno
  inverseSurface: Color(0xFF424242), // Fundo escuro (para contraste)
  inversePrimary: Color(0xFFAAB6FE), // Azul mais claro
  surfaceTint: primaryBlue, // Cor de elevação/sombra
  outlineVariant: Color(0xFF9E9E9E),
  scrim: Color(0xFF000000),
);

// Dark Theme Colors
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFAAB6FE), // Azul mais claro no tema escuro
  onPrimary: Color(0xFF1A237E),
  primaryContainer: Color(0xFF303F9F),
  onPrimaryContainer: Color(0xFFE8EAF6),

  secondary: Color(0xFF81C784), // Verde mais suave no tema escuro
  onSecondary: Color(0xFF2E7D32),
  secondaryContainer: Color(0xFF388E3C),
  onSecondaryContainer: Color(0xFFC8E6C9),

  tertiary: Color(0xFFFFD54F), // Amarelo mais suave no tema escuro
  onTertiary: Color(0xFF757575),
  tertiaryContainer: Color(0xFFFFA000),
  onTertiaryContainer: Color(0xFFFFECB3),

  error: Color(0xFFFF8A65), // Vermelho/Laranja mais suave
  errorContainer: Color(0xFFD84315),
  onError: Color(0xFF000000),
  onErrorContainer: Color(0xFFFFD1C4),

  surface: Color(0xFF1E1E1E), // Fundo escuro
  onSurface: Color(0xFFE0E0E0), // Texto claro
  surfaceContainerHighest: Color(0xFF333333), // Cor de cards/divisões
  onSurfaceVariant: Color(0xFFB0BEC5),

  outline: Color(0xFF757575),
  inverseSurface: Color(0xFFF5F5F5), // Fundo claro (para contraste)
  inversePrimary: primaryBlue,
  surfaceTint: Color(0xFFAAB6FE),
  outlineVariant: Color(0xFF546E7A),
  scrim: Color(0xFF000000),
);

// Aplica a paleta de cores ao ThemeData
final ThemeData ikanbanLightTheme =
    ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true).copyWith(
      // Configurações visuais que se destacam
      appBarTheme: const AppBarTheme(
        // Usa o azul vibrante como fundo
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0, // Design clean
      ),
      // Floating Action Button com o verde de ação
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryGreen,
        foregroundColor: Colors.white,
      ),
      // Estilo dos cards (para o quadro Kanban)
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor:
            Colors.transparent, // Impede que a cor primária manche o card
      ),
    );

final ThemeData ikanbanDarkTheme =
    ThemeData.from(colorScheme: darkColorScheme, useMaterial3: true).copyWith(
      // Configurações visuais que se destacam
      appBarTheme: const AppBarTheme(
        // Usa um tom escuro/primário para a AppBar
        backgroundColor: Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // Floating Action Button com o verde mais suave
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF81C784),
        foregroundColor: Colors.black,
      ),
      // Estilo dos cards (para o quadro Kanban)
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Cards um pouco mais claros que o fundo
        color: darkColorScheme.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
      ),
    );
