import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_model.freezed.dart';

@freezed
abstract class OnBoardingModel with _$OnBoardingModel {
  const factory OnBoardingModel({
    required String title,
    required String description,
    required String imagePath,
  }) = _OnBoardingModel;
}
