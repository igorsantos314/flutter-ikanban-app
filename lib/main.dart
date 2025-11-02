// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/ikanban_theme.dart';
import 'package:flutter_ikanban_app/shared/theme/data/theme_repository_impl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependecy Injection
  setupLocator();

  final theme = await ThemeRepositoryImpl.getThemePrefs();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..setTheme(theme),
      child: const iKanbanApp(),
    ),
  );
}

class iKanbanApp extends StatelessWidget {
  const iKanbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'iKanban',
      routerConfig: AppNavigation.router,
      themeMode: themeProvider.themeMode,
      theme: ikanbanLightTheme,
      darkTheme: ikanbanDarkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
    );
  }
}
