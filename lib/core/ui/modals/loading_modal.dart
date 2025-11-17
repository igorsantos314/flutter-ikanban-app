import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Carregando..."),
          ],
        ),
      ),
    );
  }

  static bool _isLoading = false;

  static void displayLoading(BuildContext context, {required bool isShow}) {
    if (isShow && !_isLoading) {
      _isLoading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (_) => const LoadingModal(),
      ).then((_) {
        _isLoading = false;
      });
    } else if (!isShow && _isLoading) {
      _isLoading = false;
      
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
