import 'package:flutter/material.dart';

void showAboutDeveloperDialog(BuildContext context) {
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