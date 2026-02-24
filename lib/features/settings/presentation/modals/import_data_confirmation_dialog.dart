import 'package:flutter/material.dart';

/// Mostra um dialog de confirmação antes de importar dados
/// 
/// Retorna `true` se o usuário confirmar a importação, `false` caso contrário
Future<bool> showImportDataConfirmationDialog(BuildContext context) async {
  final theme = Theme.of(context);
  
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Impede fechar clicando fora
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: theme.colorScheme.error,
        size: 48,
      ),
      title: const Text(
        'Atenção: Dados Serão Perdidos',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ao importar um backup:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildWarningItem(
            context,
            icon: Icons.delete_forever,
            text: 'TODOS os dados atuais serão deletados permanentemente',
          ),
          const SizedBox(height: 8),
          _buildWarningItem(
            context,
            icon: Icons.restore,
            text: 'Não será possível desfazer esta ação',
          ),
          const SizedBox(height: 8),
          _buildWarningItem(
            context,
            icon: Icons.backup,
            text: 'Recomendamos fazer backup dos dados atuais antes de continuar',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta ação não pode ser desfeita!',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: const Text('Continuar e Importar'),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsAlignment: MainAxisAlignment.spaceBetween,
    ),
  );

  return result ?? false;
}

Widget _buildWarningItem(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  final theme = Theme.of(context);
  
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 20,
        color: theme.colorScheme.error,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
      ),
    ],
  );
}
