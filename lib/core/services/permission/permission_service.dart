import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PermissionType {
  notification,
  camera,
  storage,
  // Adicione outros tipos de permissão conforme necessário
}

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Keys para SharedPreferences
  static const String _permissionDenialCountPrefix = 'permission_denial_count_';
  static const String _permissionPermanentlyDeniedPrefix = 'permission_permanently_denied_';
  static const int _maxDenialsBeforeRationale = 2;

  /// Verifica se uma permissão está concedida
  Future<bool> isPermissionGranted(PermissionType type) async {
    final permission = _getPermission(type);
    if (permission == null) return false;

    final status = await permission.status;
    return status.isGranted;
  }

  /// Solicita uma permissão, gerenciando contadores e rationale
  Future<PermissionRequestResult> requestPermission(
    PermissionType type, {
    BuildContext? context,
    String? rationaleTitle,
    String? rationaleMessage,
  }) async {
    final permission = _getPermission(type);
    if (permission == null) {
      return PermissionRequestResult.error;
    }

    // Verifica se a permissão já está concedida
    if (await isPermissionGranted(type)) {
      return PermissionRequestResult.granted;
    }

    // Verifica se foi marcada como permanentemente negada
    final isPermanentlyDenied = await _isPermanentlyDeniedByUser(type);
    if (isPermanentlyDenied) {
      log('[PermissionService] Permission $type was permanently denied by user');
      
      // Mostra rationale se o contexto foi fornecido
      if (context != null && context.mounted) {
        final shouldOpenSettings = await _showPermanentlyDeniedDialog(
          context,
          rationaleTitle ?? _getDefaultRationaleTitle(type),
          rationaleMessage ?? _getDefaultRationaleMessage(type),
        );

        if (shouldOpenSettings) {
          await openSettings();
          // Após abrir as configurações, verifica novamente
          final newStatus = await permission.status;
          return newStatus.isGranted
              ? PermissionRequestResult.granted
              : PermissionRequestResult.permanentlyDenied;
        }
      }
      
      return PermissionRequestResult.permanentlyDenied;
    }

    // Obtém o contador de negações
    final denialCount = await _getDenialCount(type);

    // Se já foi negado algumas vezes, mostra o rationale antes de pedir
    if (denialCount >= _maxDenialsBeforeRationale &&
        context != null &&
        context.mounted) {
      final shouldProceed = await _showRationaleDialog(
        context,
        rationaleTitle ?? _getDefaultRationaleTitle(type),
        rationaleMessage ?? _getDefaultRationaleMessage(type),
      );

      if (!shouldProceed) {
        await _markAsPermanentlyDenied(type);
        return PermissionRequestResult.denied;
      }
    }

    // Solicita a permissão
    final status = await permission.request();

    if (status.isGranted) {
      // Reseta o contador se foi concedida
      await _resetDenialCount(type);
      return PermissionRequestResult.granted;
    } else if (status.isPermanentlyDenied) {
      await _markAsPermanentlyDenied(type);
      return PermissionRequestResult.permanentlyDenied;
    } else {
      // Incrementa o contador de negações
      await _incrementDenialCount(type);
      return PermissionRequestResult.denied;
    }
  }

  /// Verifica se deve mostrar o rationale para uma permissão
  Future<bool> shouldShowRationale(PermissionType type) async {
    final permission = _getPermission(type);
    if (permission == null) return false;

    final status = await permission.status;
    return status.isDenied || status.isPermanentlyDenied;
  }

  /// Abre as configurações do app  
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  // Métodos privados para gerenciar contadores

  Future<int> _getDenialCount(PermissionType type) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_permissionDenialCountPrefix${type.name}') ?? 0;
  }

  Future<void> _incrementDenialCount(PermissionType type) async {
    final prefs = await SharedPreferences.getInstance();
    final count = await _getDenialCount(type);
    await prefs.setInt('$_permissionDenialCountPrefix${type.name}', count + 1);
    log('[PermissionService] Denial count for $type: ${count + 1}');
  }

  Future<void> _resetDenialCount(PermissionType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_permissionDenialCountPrefix${type.name}');
    await prefs.remove('$_permissionPermanentlyDeniedPrefix${type.name}');
    log('[PermissionService] Reset denial count for $type');
  }

  Future<void> _markAsPermanentlyDenied(PermissionType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_permissionPermanentlyDeniedPrefix${type.name}', true);
    log('[PermissionService] Marked $type as permanently denied');
  }

  Future<bool> _isPermanentlyDeniedByUser(PermissionType type) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_permissionPermanentlyDeniedPrefix${type.name}') ?? false;
  }

  // Mapeia o tipo de permissão para a permissão do package
  Permission? _getPermission(PermissionType type) {
    switch (type) {
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.storage:
        return Permission.storage;
    }
  }

  // Diálogos de rationale

  Future<bool> _showRationaleDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não permitir'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Permitir'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<bool> _showPermanentlyDeniedDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            Text(
              'Para habilitar esta permissão, vá em Configurações > Permissões do app.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.settings),
            label: const Text('Abrir Configurações'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Mensagens padrão de rationale

  String _getDefaultRationaleTitle(PermissionType type) {
    switch (type) {
      case PermissionType.notification:
        return 'Permissão de Notificações';
      case PermissionType.camera:
        return 'Permissão de Câmera';
      case PermissionType.storage:
        return 'Permissão de Armazenamento';
    }
  }

  String _getDefaultRationaleMessage(PermissionType type) {
    switch (type) {
      case PermissionType.notification:
        return 'Este app precisa de permissão para enviar notificações e lembrá-lo sobre suas tarefas. '
            'Sem essa permissão, você não receberá lembretes das suas tarefas agendadas.';
      case PermissionType.camera:
        return 'Este app precisa de permissão para acessar a câmera.';
      case PermissionType.storage:
        return 'Este app precisa de permissão para acessar o armazenamento.';
    }
  }

  /// Reseta todas as permissões marcadas como permanentemente negadas
  /// (útil para desenvolvimento/debug)
  Future<void> resetAllPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_permissionDenialCountPrefix) ||
          key.startsWith(_permissionPermanentlyDeniedPrefix)) {
        await prefs.remove(key);
      }
    }
    
    log('[PermissionService] Reset all permissions');
  }
}

enum PermissionRequestResult {
  granted,
  denied,
  permanentlyDenied,
  error,
}
