

import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsRepositoryErrors', () {
    group('notFound', () {
      test('should create notFound error with message and throwable', () {
        const error = SettingsRepositoryErrors.notFound(
          message: 'Settings not found',
          throwable: 'exception',
        );
        expect(error.message, 'Settings not found');
        expect(error.throwable, 'exception');
      });

      test('should create notFound error without parameters', () {
        const error = SettingsRepositoryErrors.notFound();
        expect(error.message, isNull);
        expect(error.throwable, isNull);
      });

      test('should create notFound error with only message', () {
        const error = SettingsRepositoryErrors.notFound(
          message: 'Settings not found',
        );
        expect(error.message, 'Settings not found');
        expect(error.throwable, isNull);
      });
    });

    group('databaseError', () {
      test('should create databaseError with message and throwable', () {
        final exception = Exception('Database error');
        final error = SettingsRepositoryErrors.databaseError(
          message: 'Database operation failed',
          throwable: exception,
        );
        expect(error.message, 'Database operation failed');
        expect(error.throwable, exception);
      });

      test('should create databaseError without parameters', () {
        const error = SettingsRepositoryErrors.databaseError();
        expect(error.message, isNull);
        expect(error.throwable, isNull);
      });

      test('should create databaseError with only throwable', () {
        final exception = Exception('Database error');
        final error = SettingsRepositoryErrors.databaseError(
          throwable: exception,
        );
        expect(error.message, isNull);
        expect(error.throwable, exception);
      });
    });

    group('validationError', () {
      test('should create validationError with message and throwable', () {
        final exception = Exception('Validation failed');
        final error = SettingsRepositoryErrors.validationError(
          message: 'Invalid settings data',
          throwable: exception,
        );
        expect(error.message, 'Invalid settings data');
        expect(error.throwable, exception);
      });

      test('should create validationError without parameters', () {
        const error = SettingsRepositoryErrors.validationError();
        expect(error.message, isNull);
        expect(error.throwable, isNull);
      });

      test('should create validationError with only message', () {
        const error = SettingsRepositoryErrors.validationError(
          message: 'Invalid settings',
        );
        expect(error.message, 'Invalid settings');
        expect(error.throwable, isNull);
      });
    });

    group('networkError', () {
      test('should create networkError with message and throwable', () {
        final exception = Exception('Network error');
        final error = SettingsRepositoryErrors.networkError(
          message: 'Connection failed',
          throwable: exception,
        );
        expect(error.message, 'Connection failed');
        expect(error.throwable, exception);
      });

      test('should create networkError without parameters', () {
        const error = SettingsRepositoryErrors.networkError();
        expect(error.message, isNull);
        expect(error.throwable, isNull);
      });

      test('should create networkError with only message', () {
        const error = SettingsRepositoryErrors.networkError(
          message: 'Network unavailable',
        );
        expect(error.message, 'Network unavailable');
        expect(error.throwable, isNull);
      });
    });

    group('genericError', () {
      test('should create genericError with message and throwable', () {
        final exception = Exception('Generic error');
        final error = SettingsRepositoryErrors.genericError(
          message: 'Something went wrong',
          throwable: exception,
        );
        expect(error.message, 'Something went wrong');
        expect(error.throwable, exception);
      });

      test('should create genericError without parameters', () {
        const error = SettingsRepositoryErrors.genericError();
        expect(error.message, isNull);
        expect(error.throwable, isNull);
      });

      test('should create genericError with only throwable', () {
        final exception = Exception('Error');
        final error = SettingsRepositoryErrors.genericError(
          throwable: exception,
        );
        expect(error.message, isNull);
        expect(error.throwable, exception);
      });
    });

    group('equality', () {
      test('should be equal when same type and same values', () {
        const error1 = SettingsRepositoryErrors.notFound(
          message: 'Not found',
        );
        const error2 = SettingsRepositoryErrors.notFound(
          message: 'Not found',
        );
        expect(error1, equals(error2));
        expect(error1.hashCode, equals(error2.hashCode));
      });

      test('should not be equal when different types', () {
        const error1 = SettingsRepositoryErrors.notFound(
          message: 'Error',
        );
        const error2 = SettingsRepositoryErrors.databaseError(
          message: 'Error',
        );
        expect(error1, isNot(equals(error2)));
        expect(error1.hashCode, isNot(equals(error2.hashCode)));
      });

      test('should not be equal when same type but different messages', () {
        const error1 = SettingsRepositoryErrors.notFound(
          message: 'Error 1',
        );
        const error2 = SettingsRepositoryErrors.notFound(
          message: 'Error 2',
        );
        expect(error1, isNot(equals(error2)));
      });

      test('should not be equal when same type and message but different throwables', () {
        final exception1 = Exception('Exception 1');
        final exception2 = Exception('Exception 2');
        final error1 = SettingsRepositoryErrors.databaseError(
          message: 'Error',
          throwable: exception1,
        );
        final error2 = SettingsRepositoryErrors.databaseError(
          message: 'Error',
          throwable: exception2,
        );
        expect(error1, isNot(equals(error2)));
      });
    });

    group('copyWith', () {
      test('should create copy with updated message for notFound', () {
        const error = SettingsRepositoryErrors.notFound(
          message: 'Original message',
        );
        final updatedError = error.copyWith(message: 'Updated message');
        expect(updatedError.message, 'Updated message');
        expect(updatedError.throwable, isNull);
      });

      test('should create copy with updated throwable for databaseError', () {
        final originalException = Exception('Original');
        final newException = Exception('New');
        final error = SettingsRepositoryErrors.databaseError(
          message: 'Error',
          throwable: originalException,
        );
        final updatedError = error.copyWith(throwable: newException);
        expect(updatedError.message, 'Error');
        expect(updatedError.throwable, newException);
      });
    });

    group('when method', () {
      test('should execute correct callback for notFound', () {
        const error = SettingsRepositoryErrors.notFound();
        var callbackExecuted = false;
        error.when(
          notFound: (_, __) => callbackExecuted = true,
          databaseError: (_, __) => fail('Should not execute'),
          validationError: (_, __) => fail('Should not execute'),
          networkError: (_, __) => fail('Should not execute'),
          genericError: (_, __) => fail('Should not execute'),
        );
        expect(callbackExecuted, true);
      });

      test('should execute correct callback for databaseError', () {
        const error = SettingsRepositoryErrors.databaseError();
        var callbackExecuted = false;
        error.when(
          notFound: (_, __) => fail('Should not execute'),
          databaseError: (_, __) => callbackExecuted = true,
          validationError: (_, __) => fail('Should not execute'),
          networkError: (_, __) => fail('Should not execute'),
          genericError: (_, __) => fail('Should not execute'),
        );
        expect(callbackExecuted, true);
      });

      test('should execute correct callback for validationError', () {
        const error = SettingsRepositoryErrors.validationError();
        var callbackExecuted = false;
        error.when(
          notFound: (_, __) => fail('Should not execute'),
          databaseError: (_, __) => fail('Should not execute'),
          validationError: (_, __) => callbackExecuted = true,
          networkError: (_, __) => fail('Should not execute'),
          genericError: (_, __) => fail('Should not execute'),
        );
        expect(callbackExecuted, true);
      });

      test('should execute correct callback for networkError', () {
        const error = SettingsRepositoryErrors.networkError();
        var callbackExecuted = false;
        error.when(
          notFound: (_, __) => fail('Should not execute'),
          databaseError: (_, __) => fail('Should not execute'),
          validationError: (_, __) => fail('Should not execute'),
          networkError: (_, __) => callbackExecuted = true,
          genericError: (_, __) => fail('Should not execute'),
        );
        expect(callbackExecuted, true);
      });

      test('should execute correct callback for genericError', () {
        const error = SettingsRepositoryErrors.genericError();
        var callbackExecuted = false;
        error.when(
          notFound: (_, __) => fail('Should not execute'),
          databaseError: (_, __) => fail('Should not execute'),
          validationError: (_, __) => fail('Should not execute'),
          networkError: (_, __) => fail('Should not execute'),
          genericError: (_, __) => callbackExecuted = true,
        );
        expect(callbackExecuted, true);
      });
    });

    group('maybeWhen', () {
      test('should execute specific callback when provided', () {
        const error = SettingsRepositoryErrors.notFound();
        var specificCallbackExecuted = false;
        error.maybeWhen(
          notFound: (_, __) => specificCallbackExecuted = true,
          orElse: () => fail('Should not execute orElse'),
        );
        expect(specificCallbackExecuted, true);
      });

      test('should execute orElse when specific callback not provided', () {
        const error = SettingsRepositoryErrors.notFound();
        var orElseExecuted = false;
        error.maybeWhen(
          databaseError: (_, __) => fail('Should not execute'),
          orElse: () => orElseExecuted = true,
        );
        expect(orElseExecuted, true);
      });
    });

    group('map method', () {
      test('should map notFound correctly', () {
        const error = SettingsRepositoryErrors.notFound();
        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );
        expect(result, 'notFound');
      });

      test('should map databaseError correctly', () {
        const error = SettingsRepositoryErrors.databaseError();
        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );
        expect(result, 'databaseError');
      });

      test('should map validationError correctly', () {
        const error = SettingsRepositoryErrors.validationError();
        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );
        expect(result, 'validationError');
      });

      test('should map networkError correctly', () {
        const error = SettingsRepositoryErrors.networkError();
        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );
        expect(result, 'networkError');
      });

      test('should map genericError correctly', () {
        const error = SettingsRepositoryErrors.genericError();
        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );
        expect(result, 'genericError');
      });
    });
  });
}
