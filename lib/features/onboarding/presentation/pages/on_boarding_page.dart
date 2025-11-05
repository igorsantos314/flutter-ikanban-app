import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:go_router/go_router.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to the Onboarding Page!'),
            ElevatedButton(
              onPressed: () {
                AppNavigation.navigateToHome(context);
              },
              child: const Text('Finish Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}
