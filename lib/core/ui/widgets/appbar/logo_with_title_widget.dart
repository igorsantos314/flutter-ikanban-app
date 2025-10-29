import 'package:flutter/material.dart';

class LogoWithTitleWidget extends StatelessWidget {
  const LogoWithTitleWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(
          width: 64,
          height: 64,
          image: AssetImage('assets/images/logo.png')),
        Text(
          "iKanban",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}