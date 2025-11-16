import 'package:flutter_ikanban_app/core/use_cases/theme/get_theme_use_case.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  late MockThemeRepository mockRepository;
  late GetThemeUseCase useCase;

  setUp(() {
    mockRepository = MockThemeRepository();
    useCase = GetThemeUseCase(mockRepository);
  });

  group('GetThemeUseCase', () {
    group('execute', () {
      test('should call repository and return theme', () async {
        // Arrange
        when(() => mockRepository.getTheme())
            .thenAnswer((_) async => AppTheme.system);

        // Act
        await useCase.execute();

        // Assert
        verify(() => mockRepository.getTheme()).called(1);
      });
    });
  });
}
