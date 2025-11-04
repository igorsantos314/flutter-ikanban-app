import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/repository/on_boarding_repository.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/errors/on_boarding_errors.dart';

enum IsOnBoardingCompletedError { genericError, notFound }

class IsOnBoardingCompleted {
  final OnBoardingRepository repository;

  IsOnBoardingCompleted(this.repository);

  Future<Outcome<bool, IsOnBoardingCompletedError>> execute() async {
    final result = await repository.isOnBoardingCompleted();
    return result.when(
      success: (data) => Outcome.success(value: data),
      failure: (error, message, throwable) {
        switch (error) {
          case OnBoardingError.notFound:
            return const Outcome.failure(
              error: IsOnBoardingCompletedError.notFound,
            );
          default:
            return const Outcome.failure(
              error: IsOnBoardingCompletedError.genericError,
            );
        }
      },
    );
  }
}
