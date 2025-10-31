import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ikanban_app/core/theme/theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageContent();
  }
}

class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({super.key});

  Future<void> _exportData(BuildContext context) async {
    try {
      // Simulação da exportação de dados
      // Em uma implementação real, você buscaria os dados do banco
      final exportData = {
        'app': 'iKanban',
        'version': '1.0.0+1',
        'exportDate': DateTime.now().toIso8601String(),
        'tasks': [
          // Aqui você colocaria os dados reais das tarefas
          {
            'id': 1,
            'title': 'Exemplo de tarefa',
            'description': 'Esta é uma tarefa de exemplo',
            'status': 'backlog',
            'priority': 'low',
            'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          }
        ],
        'boards': [],
        'settings': {
          'theme': Provider.of<ThemeProvider>(context, listen: false).themeMode.name,
        }
      };

      final jsonData = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // Obter diretório de documentos
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ikanban_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      
      // Escrever dados no arquivo
      await file.writeAsString(jsonData);

      // Copiar dados para clipboard como alternativa
      await Clipboard.setData(ClipboardData(text: jsonData));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Dados exportados e copiados para área de transferência!'),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Ver Local',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Arquivo Salvo'),
                    content: Text('Arquivo salvo em:\n${file.path}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Erro ao exportar dados: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Sobre o Desenvolvedor'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👨‍💻 Igor Santos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Desenvolvedor apaixonado por criar soluções que facilitam o dia a dia das pessoas.',
            ),
            SizedBox(height: 12),
            Text(
              '💙 Desenvolvido com Flutter para te ajudar a ser mais produtivo!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              '📧 GitHub: @igorsantos314',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Seção de Tema
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return SwitchListTile(
                              title: const Text('Tema Escuro'),
                              subtitle: Text(
                                themeProvider.themeMode == ThemeMode.dark
                                    ? 'Interface escura ativada'
                                    : 'Interface clara ativada',
                              ),
                              value: themeProvider.themeMode == ThemeMode.dark,
                              onChanged: (bool value) {
                                themeProvider.toggleTheme(value);
                                HapticFeedback.lightImpact();
                              },
                              secondary: Icon(
                                themeProvider.themeMode == ThemeMode.dark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Seção de Dados
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.file_download),
                          title: const Text('Exportar Dados'),
                          subtitle: const Text('Faça backup de todas suas tarefas e configurações'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _exportData(context),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),

          // Rodapé com informações
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
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Versão 1.0.0+1',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Informações do desenvolvedor
                GestureDetector(
                  onTap: () => _showAboutDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '💙 ',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Desenvolvido por ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                        ' para te ajudar 😊',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
