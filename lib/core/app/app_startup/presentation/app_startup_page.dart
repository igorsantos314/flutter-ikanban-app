import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_event.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_state.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';

class AppStartupPage extends StatelessWidget {
  const AppStartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppStartupBloc(checkOnboardingCompletedUseCase: getIt()),
      child: AppStartupPageContent(),
    );
  }
}

class AppStartupPageContent extends StatefulWidget {
  const AppStartupPageContent({super.key});

  @override
  State<AppStartupPageContent> createState() => _AppStartupPageContentState();
}

class _AppStartupPageContentState extends State<AppStartupPageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<AppStartupBloc>().add(const InitializeApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStartupBloc, AppStartupState>(
      builder: (context, state) {
        log('[UI] AppStartupPage building with state: $state');

        return state.when(
          initial: () => _buildLoading(),
          loading: () => _buildLoading(),
          loaded: (isOnboardingComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (isOnboardingComplete) {
                log('[UI] Onboarding complete, navigating to Home');
                AppNavigation.navigateToHome(context);
              } else {
                log('[UI] Onboarding not complete, navigating to Onboarding');
                AppNavigation.navigateToOnboarding(context);
              }
            });
            return _buildLoading();
          },
          error: (message) => Scaffold(
            body: Center(child: Text('Não foi possível iniciar o app')),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Iniciando o iKanban...'),
          ],
        ),
      ),
    );
  }
}
