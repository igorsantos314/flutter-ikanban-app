import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/errors/on_boarding_errors.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/repository/on_boarding_repository.dart';
import 'package:flutter_ikanban_app/features/onboarding/infra/on_boarding_data_source.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingDataSource _dataSource;

  OnBoardingRepositoryImpl(this._dataSource);

  @override
  Future<Outcome<void, OnBoardingError>> completeOnBoarding() {
    try {
      return _dataSource.completeOnBoarding().then((_) {
        return const Outcome.success();
      });
    } catch (e) {
      return Future.value(
        Outcome.failure(error: OnBoardingError.genericError()),
      );
    }
  }

  @override
  Future<Outcome<bool, OnBoardingError>> isOnBoardingCompleted() {
    try {
      return _dataSource.isOnBoardingCompleted().then((completed) {
        return Outcome.success(value: completed);
      });
    } catch (e) {
      return Future.value(
        Outcome.failure(error: OnBoardingError.genericError()),
      );
    }
  }
}
