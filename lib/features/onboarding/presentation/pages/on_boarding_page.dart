import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/model/on_boarding_model.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/events/on_boarding_event.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/states/on_boarding_states.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingBloc(getIt()),
      child: const OnBoardingPageContent(),
    );
  }
}

class OnBoardingPageContent extends StatefulWidget {
  const OnBoardingPageContent({super.key});

  @override
  State<OnBoardingPageContent> createState() => _OnBoardingPageContentState();
}

class _OnBoardingPageContentState extends State<OnBoardingPageContent> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnBoardingModel> _onboardingData = [
    const OnBoardingModel(
      title: '📋 Organize suas Tarefas',
      description:
          'Crie e gerencie suas tarefas de forma simples e intuitiva. Visualize tudo em um local organizado.',
      imagePath: 'assets/images/screen_shots/show_taks_list_view.png',
    ),
    const OnBoardingModel(
      title: '📊 Visualização em Grade',
      description:
          'Veja suas tarefas em diferentes layouts. Grid view para uma visão ampla de todos os seus projetos.',
      imagePath: 'assets/images/screen_shots/shows_task_grid_view_screen.png',
    ),
    const OnBoardingModel(
      title: '✨ Criação Rápida',
      description:
          'Adicione novas tarefas rapidamente com formulário intuitivo. Categorize por prioridade, status e muito mais.',
      imagePath: 'assets/images/screen_shots/create_new_task_screen.png',
    ),
    const OnBoardingModel(
      title: '⚙️ Configurações Personalizadas',
      description:
          'Personalize o app do seu jeito. Tema escuro/claro, exportação de dados e muito mais.',
      imagePath: 'assets/images/screen_shots/settings_screen.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    context.read<OnBoardingBloc>().add(CompleteOnBoardingEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<OnBoardingBloc, OnBoardingState>(
          listener: (context, state) {
            if (state.isOnBoardingCompleted) {
              AppNavigation.navigateToHome(context);
            }
          },
        ),
      ],
      child: BlocConsumer<OnBoardingBloc, OnBoardingState>(
        listener: (context, state) => state.isLoading,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // Header with Skip button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Logo
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/name_logo_right.png',
                                    width: 128,
                                  ),
                                ],
                              ),

                              TextButton(
                                onPressed: _skipOnboarding,
                                child: Text(
                                  'Pular',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PageView with content
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemCount: _onboardingData.length,
                            itemBuilder: (context, index) {
                              final data = _onboardingData[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  children: [
                                    // Image with blur at the bottom
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 50,
                                          bottom: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 50,
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          data.imagePath,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    // Text content
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Title
                                          Text(
                                            data.title,
                                            style: theme
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),

                                          const SizedBox(height: 16),

                                          // Description
                                          Text(
                                            data.description,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.7),
                                                  height: 1.5,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Page indicators and navigation buttons
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Page indicators (dots)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  _onboardingData.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: _currentIndex == index ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: _currentIndex == index
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Navigation buttons
                              Row(
                                children: [
                                  // Previous button (only appears if not on the first page)
                                  if (_currentIndex > 0)
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _previousPage,
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Text('Anterior'),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          side: BorderSide(
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const Expanded(child: SizedBox()),

                                  const SizedBox(width: 16),

                                  // Next/Start button
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _nextPage,
                                      icon: Icon(
                                        _currentIndex ==
                                                _onboardingData.length - 1
                                            ? Icons.check
                                            : Icons.arrow_forward,
                                      ),
                                      label: Text(
                                        _currentIndex ==
                                                _onboardingData.length - 1
                                            ? 'Começar'
                                            : 'Próximo',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
