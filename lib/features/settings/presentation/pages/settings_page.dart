import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_mapper.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_provider.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/events/settings_events.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/modals/about_developer_modal.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/states/settings_state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        saveSettingsUseCase: getIt(),
        loadSettingsUseCase: getIt(),
        exportDataUseCase: getIt(),
        importDataUseCase: getIt(),
      )..add(LoadSettingsEvent()),
      child: const SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatefulWidget {
  const SettingsPageContent({super.key});

  @override
  State<SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {

  Widget _buildThemeOption(
    BuildContext context,
    ThemeData theme,
    ThemeProvider themeProvider,
    AppTheme themeOption,
    String title,
    String subtitle,
    IconData iconData,
    AppTheme currentTheme,
  ) {
    final isSelected = currentTheme == themeOption;

    return InkWell(
      onTap: () {
        // Evita múltiplos taps
        if (isSelected) return;
        
        // Atualiza o provider imediatamente para feedback visual
        themeProvider.setTheme(themeOption);
        
        // Salva no BLoC (que persiste no repository)
        context.read<SettingsBloc>().add(UpdateThemeEvent(themeOption));
        
        HapticFeedback.lightImpact();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              iconData,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  width: 2,
                ),
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: theme.colorScheme.onPrimary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) =>
              previous.showNotification != current.showNotification,
          listener: (context, state) {
            if (state.showNotification) {
              showCustomSnackBar(
                context,
                state.notificationMessage,
                state.notificationType,
              );
              context.read<SettingsBloc>().add(SettingsResetNotification());
            }
          },
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Configurações'),
              centerTitle: true,
              elevation: 2,
            ),
            body: Column(
              children: [
                Expanded(
                  child: state.isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text("Carregando ..."),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            // Theme Section
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.palette,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Aparência',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Consumer<ThemeProvider>(
                                      builder: (context, themeProvider, child) {
                                        final currentTheme =
                                            ThemeMapper.fromThemeMode(
                                              themeProvider.themeMode,
                                            );

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Escolha o tema do aplicativo:',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.8),
                                                  ),
                                            ),
                                            const SizedBox(height: 16),

                                            // Opção Sistema
                                            _buildThemeOption(
                                              context,
                                              theme,
                                              themeProvider,
                                              AppTheme.system,
                                              'Sistema',
                                              'Segue a configuração do sistema',
                                              Icons.brightness_auto,
                                              currentTheme,
                                            ),

                                            // Opção Claro
                                            _buildThemeOption(
                                              context,
                                              theme,
                                              themeProvider,
                                              AppTheme.light,
                                              'Claro',
                                              'Interface clara sempre ativada',
                                              Icons.light_mode,
                                              currentTheme,
                                            ),

                                            // Opção Escuro
                                            _buildThemeOption(
                                              context,
                                              theme,
                                              themeProvider,
                                              AppTheme.dark,
                                              'Escuro',
                                              'Interface escura sempre ativada',
                                              Icons.dark_mode,
                                              currentTheme,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Data Section
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.cloud_download,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Dados',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      leading: const Icon(Icons.file_download),
                                      title: const Text('Exportar Dados'),
                                      subtitle: Column(
                                        children: [
                                          const Text(
                                            'Faça backup de todas suas tarefas e configurações',
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Recomendamos usar serviços de nuvem como o Google Drive, para armazenar seu backup com segurança.',
                                            style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                      onTap: () => context
                                          .read<SettingsBloc>()
                                          .add(ExportDataEvent()),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.file_upload),
                                      title: const Text('Importar Dados'),
                                      subtitle: const Text(
                                        'Importar backup de todas suas tarefas e configurações',
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                      onTap: () => context
                                          .read<SettingsBloc>()
                                          .add(ImportDataEvent(filePath: "")),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Footer
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                border: Border(
                                  top: BorderSide(
                                    color: theme.dividerColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Informações da versão
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        state.appVersion,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Informações do desenvolvedor
                                  _aboutDeveloperInfo(context, theme),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _aboutDeveloperInfo(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => showAboutDeveloperDialog(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Desenvolvido por ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            'Igor Santos',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            ' para te ajudar !',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
