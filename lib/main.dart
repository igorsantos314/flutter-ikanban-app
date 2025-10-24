// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependecy Injection
  setupLocator();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
    );
  }
}
