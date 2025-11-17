import 'package:flutter_ikanban_app/core/use_cases/theme/set_theme_use_case.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  late MockThemeRepository mockRepository;
  late SetThemeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(AppTheme.system);
  });

  setUp(() {
    mockRepository = MockThemeRepository();
    useCase = SetThemeUseCase(mockRepository);
  });

  group('SetThemeUseCase', () {
    group('execute', () {
      test('should call repository with correct theme', () async {
        // Arrange
        when(() => mockRepository.setTheme(any()))
            .thenAnswer((_) async => {});

        // Act
        await useCase.execute(AppTheme.system);

        // Assert
        verify(() => mockRepository.setTheme(AppTheme.system)).called(1);
      });

      test('should handle repository exception', () async {
        // Arrange
        when(() => mockRepository.setTheme(any()))
            .thenThrow(Exception('Repository error'));

        // Act
        await useCase.execute(AppTheme.light);

        // Assert
        verify(() => mockRepository.setTheme(AppTheme.light)).called(1);
      });
    });
  });
}
