import 'package:flutter/material.dart';

class LogoWithTitleWidget extends StatelessWidget {
  const LogoWithTitleWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(
          width: 180,
          image: AssetImage('assets/images/name_logo_right.png')),
      ],
    );
  }
}