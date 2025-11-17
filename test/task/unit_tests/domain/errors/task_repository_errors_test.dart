import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskRepositoryErrors', () {
    group('notFound', () {
      test('should create notFound error with message and throwable', () {
        const message = 'Task not found';
        final throwable = Exception('Database exception');

        final error = TaskRepositoryErrors.notFound(
          message: message,
          throwable: throwable,
        );

        expect(error, isA<TaskRepositoryErrors>());
        error.when(
          notFound: (msg, thrown) {
            expect(msg, message);
            expect(thrown, throwable);
          },
          databaseError: (_, __) => fail('Should be notFound'),
          validationError: (_, __) => fail('Should be notFound'),
          networkError: (_, __) => fail('Should be notFound'),
          genericError: (_, __) => fail('Should be notFound'),
        );
      });

      test('should create notFound error without parameters', () {
        final error = TaskRepositoryErrors.notFound();

        error.when(
          notFound: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, isNull);
          },
          databaseError: (_, __) => fail('Should be notFound'),
          validationError: (_, __) => fail('Should be notFound'),
          networkError: (_, __) => fail('Should be notFound'),
          genericError: (_, __) => fail('Should be notFound'),
        );
      });

      test('should create notFound error with only message', () {
        const message = 'Task with id 123 not found';

        final error = TaskRepositoryErrors.notFound(message: message);

        error.when(
          notFound: (msg, thrown) {
            expect(msg, message);
            expect(thrown, isNull);
          },
          databaseError: (_, __) => fail('Should be notFound'),
          validationError: (_, __) => fail('Should be notFound'),
          networkError: (_, __) => fail('Should be notFound'),
          genericError: (_, __) => fail('Should be notFound'),
        );
      });
    });

    group('databaseError', () {
      test('should create databaseError with message and throwable', () {
        const message = 'Failed to save task';
        final throwable = Exception('SQLite exception');

        final error = TaskRepositoryErrors.databaseError(
          message: message,
          throwable: throwable,
        );

        expect(error, isA<TaskRepositoryErrors>());
        error.when(
          notFound: (_, __) => fail('Should be databaseError'),
          databaseError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, throwable);
          },
          validationError: (_, __) => fail('Should be databaseError'),
          networkError: (_, __) => fail('Should be databaseError'),
          genericError: (_, __) => fail('Should be databaseError'),
        );
      });

      test('should create databaseError without parameters', () {
        final error = TaskRepositoryErrors.databaseError();

        error.when(
          notFound: (_, __) => fail('Should be databaseError'),
          databaseError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, isNull);
          },
          validationError: (_, __) => fail('Should be databaseError'),
          networkError: (_, __) => fail('Should be databaseError'),
          genericError: (_, __) => fail('Should be databaseError'),
        );
      });

      test('should create databaseError with only throwable', () {
        final throwable = Exception('Connection lost');

        final error = TaskRepositoryErrors.databaseError(throwable: throwable);

        error.when(
          notFound: (_, __) => fail('Should be databaseError'),
          databaseError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, throwable);
          },
          validationError: (_, __) => fail('Should be databaseError'),
          networkError: (_, __) => fail('Should be databaseError'),
          genericError: (_, __) => fail('Should be databaseError'),
        );
      });
    });

    group('validationError', () {
      test('should create validationError with message and throwable', () {
        const message = 'Invalid task title';
        final throwable = FormatException('Title is empty');

        final error = TaskRepositoryErrors.validationError(
          message: message,
          throwable: throwable,
        );

        expect(error, isA<TaskRepositoryErrors>());
        error.when(
          notFound: (_, __) => fail('Should be validationError'),
          databaseError: (_, __) => fail('Should be validationError'),
          validationError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, throwable);
          },
          networkError: (_, __) => fail('Should be validationError'),
          genericError: (_, __) => fail('Should be validationError'),
        );
      });

      test('should create validationError without parameters', () {
        final error = TaskRepositoryErrors.validationError();

        error.when(
          notFound: (_, __) => fail('Should be validationError'),
          databaseError: (_, __) => fail('Should be validationError'),
          validationError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, isNull);
          },
          networkError: (_, __) => fail('Should be validationError'),
          genericError: (_, __) => fail('Should be validationError'),
        );
      });

      test('should create validationError with only message', () {
        const message = 'Due date must be in the future';

        final error = TaskRepositoryErrors.validationError(message: message);

        error.when(
          notFound: (_, __) => fail('Should be validationError'),
          databaseError: (_, __) => fail('Should be validationError'),
          validationError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, isNull);
          },
          networkError: (_, __) => fail('Should be validationError'),
          genericError: (_, __) => fail('Should be validationError'),
        );
      });
    });

    group('networkError', () {
      test('should create networkError with message and throwable', () {
        const message = 'Failed to sync tasks';
        final throwable = Exception('No internet connection');

        final error = TaskRepositoryErrors.networkError(
          message: message,
          throwable: throwable,
        );

        expect(error, isA<TaskRepositoryErrors>());
        error.when(
          notFound: (_, __) => fail('Should be networkError'),
          databaseError: (_, __) => fail('Should be networkError'),
          validationError: (_, __) => fail('Should be networkError'),
          networkError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, throwable);
          },
          genericError: (_, __) => fail('Should be networkError'),
        );
      });

      test('should create networkError without parameters', () {
        final error = TaskRepositoryErrors.networkError();

        error.when(
          notFound: (_, __) => fail('Should be networkError'),
          databaseError: (_, __) => fail('Should be networkError'),
          validationError: (_, __) => fail('Should be networkError'),
          networkError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, isNull);
          },
          genericError: (_, __) => fail('Should be networkError'),
        );
      });

      test('should create networkError with only message', () {
        const message = 'Timeout while fetching tasks';

        final error = TaskRepositoryErrors.networkError(message: message);

        error.when(
          notFound: (_, __) => fail('Should be networkError'),
          databaseError: (_, __) => fail('Should be networkError'),
          validationError: (_, __) => fail('Should be networkError'),
          networkError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, isNull);
          },
          genericError: (_, __) => fail('Should be networkError'),
        );
      });
    });

    group('genericError', () {
      test('should create genericError with message and throwable', () {
        const message = 'Unexpected error occurred';
        final throwable = Exception('Unknown error');

        final error = TaskRepositoryErrors.genericError(
          message: message,
          throwable: throwable,
        );

        expect(error, isA<TaskRepositoryErrors>());
        error.when(
          notFound: (_, __) => fail('Should be genericError'),
          databaseError: (_, __) => fail('Should be genericError'),
          validationError: (_, __) => fail('Should be genericError'),
          networkError: (_, __) => fail('Should be genericError'),
          genericError: (msg, thrown) {
            expect(msg, message);
            expect(thrown, throwable);
          },
        );
      });

      test('should create genericError without parameters', () {
        final error = TaskRepositoryErrors.genericError();

        error.when(
          notFound: (_, __) => fail('Should be genericError'),
          databaseError: (_, __) => fail('Should be genericError'),
          validationError: (_, __) => fail('Should be genericError'),
          networkError: (_, __) => fail('Should be genericError'),
          genericError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, isNull);
          },
        );
      });

      test('should create genericError with only throwable', () {
        final throwable = StateError('Invalid state');

        final error = TaskRepositoryErrors.genericError(throwable: throwable);

        error.when(
          notFound: (_, __) => fail('Should be genericError'),
          databaseError: (_, __) => fail('Should be genericError'),
          validationError: (_, __) => fail('Should be genericError'),
          networkError: (_, __) => fail('Should be genericError'),
          genericError: (msg, thrown) {
            expect(msg, isNull);
            expect(thrown, throwable);
          },
        );
      });
    });

    group('equality', () {
      test('should be equal when same type and same values', () {
        const error1 = TaskRepositoryErrors.notFound(message: 'Not found');
        const error2 = TaskRepositoryErrors.notFound(message: 'Not found');

        expect(error1, equals(error2));
        expect(error1.hashCode, equals(error2.hashCode));
      });

      test('should not be equal when different types', () {
        const error1 = TaskRepositoryErrors.notFound(message: 'Error');
        const error2 = TaskRepositoryErrors.databaseError(message: 'Error');

        expect(error1, isNot(equals(error2)));
        expect(error1.hashCode, isNot(equals(error2.hashCode)));
      });

      test('should not be equal when same type but different messages', () {
        const error1 = TaskRepositoryErrors.notFound(message: 'Error 1');
        const error2 = TaskRepositoryErrors.notFound(message: 'Error 2');

        expect(error1, isNot(equals(error2)));
      });

      test('should not be equal when same type and message but different throwables', () {
        final error1 = TaskRepositoryErrors.notFound(
          message: 'Error',
          throwable: Exception('Exception 1'),
        );
        final error2 = TaskRepositoryErrors.notFound(
          message: 'Error',
          throwable: Exception('Exception 2'),
        );

        expect(error1, isNot(equals(error2)));
      });
    });

    group('copyWith', () {
      test('should create copy with updated message for notFound', () {
        const original = TaskRepositoryErrors.notFound(message: 'Original');
        
        original.when(
          notFound: (msg, thrown) {
            expect(msg, 'Original');
          },
          databaseError: (_, __) => fail('Should be notFound'),
          validationError: (_, __) => fail('Should be notFound'),
          networkError: (_, __) => fail('Should be notFound'),
          genericError: (_, __) => fail('Should be notFound'),
        );
      });

      test('should create copy with updated throwable for databaseError', () {
        final originalThrowable = Exception('Original');
        final error = TaskRepositoryErrors.databaseError(
          throwable: originalThrowable,
        );

        error.when(
          notFound: (_, __) => fail('Should be databaseError'),
          databaseError: (msg, thrown) {
            expect(thrown, originalThrowable);
          },
          validationError: (_, __) => fail('Should be databaseError'),
          networkError: (_, __) => fail('Should be databaseError'),
          genericError: (_, __) => fail('Should be databaseError'),
        );
      });
    });

    group('when method', () {
      test('should execute correct callback for notFound', () {
        const error = TaskRepositoryErrors.notFound(message: 'Not found');
        var callbackExecuted = false;

        error.when(
          notFound: (_, __) => callbackExecuted = true,
          databaseError: (_, __) => fail('Wrong callback'),
          validationError: (_, __) => fail('Wrong callback'),
          networkError: (_, __) => fail('Wrong callback'),
          genericError: (_, __) => fail('Wrong callback'),
        );

        expect(callbackExecuted, true);
      });

      test('should execute correct callback for databaseError', () {
        const error = TaskRepositoryErrors.databaseError(message: 'DB error');
        var callbackExecuted = false;

        error.when(
          notFound: (_, __) => fail('Wrong callback'),
          databaseError: (_, __) => callbackExecuted = true,
          validationError: (_, __) => fail('Wrong callback'),
          networkError: (_, __) => fail('Wrong callback'),
          genericError: (_, __) => fail('Wrong callback'),
        );

        expect(callbackExecuted, true);
      });

      test('should execute correct callback for validationError', () {
        const error = TaskRepositoryErrors.validationError(message: 'Invalid');
        var callbackExecuted = false;

        error.when(
          notFound: (_, __) => fail('Wrong callback'),
          databaseError: (_, __) => fail('Wrong callback'),
          validationError: (_, __) => callbackExecuted = true,
          networkError: (_, __) => fail('Wrong callback'),
          genericError: (_, __) => fail('Wrong callback'),
        );

        expect(callbackExecuted, true);
      });

      test('should execute correct callback for networkError', () {
        const error = TaskRepositoryErrors.networkError(message: 'No network');
        var callbackExecuted = false;

        error.when(
          notFound: (_, __) => fail('Wrong callback'),
          databaseError: (_, __) => fail('Wrong callback'),
          validationError: (_, __) => fail('Wrong callback'),
          networkError: (_, __) => callbackExecuted = true,
          genericError: (_, __) => fail('Wrong callback'),
        );

        expect(callbackExecuted, true);
      });

      test('should execute correct callback for genericError', () {
        const error = TaskRepositoryErrors.genericError(message: 'Generic');
        var callbackExecuted = false;

        error.when(
          notFound: (_, __) => fail('Wrong callback'),
          databaseError: (_, __) => fail('Wrong callback'),
          validationError: (_, __) => fail('Wrong callback'),
          networkError: (_, __) => fail('Wrong callback'),
          genericError: (_, __) => callbackExecuted = true,
        );

        expect(callbackExecuted, true);
      });
    });

    group('maybeWhen', () {
      test('should execute specific callback when provided', () {
        const error = TaskRepositoryErrors.notFound(message: 'Not found');
        var specificCallbackExecuted = false;

        error.maybeWhen(
          notFound: (_, __) => specificCallbackExecuted = true,
          orElse: () => fail('Should not execute orElse'),
        );

        expect(specificCallbackExecuted, true);
      });

      test('should execute orElse when specific callback not provided', () {
        const error = TaskRepositoryErrors.notFound(message: 'Not found');
        var orElseExecuted = false;

        error.maybeWhen(
          databaseError: (_, __) => fail('Should not execute'),
          orElse: () => orElseExecuted = true,
        );

        expect(orElseExecuted, true);
      });
    });

    group('map method', () {
      test('should map to correct type for notFound', () {
        const error = TaskRepositoryErrors.notFound(message: 'Not found');

        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );

        expect(result, 'notFound');
      });

      test('should map to correct type for databaseError', () {
        const error = TaskRepositoryErrors.databaseError(message: 'DB error');

        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );

        expect(result, 'databaseError');
      });

      test('should map to correct type for validationError', () {
        const error = TaskRepositoryErrors.validationError(message: 'Invalid');

        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );

        expect(result, 'validationError');
      });

      test('should map to correct type for networkError', () {
        const error = TaskRepositoryErrors.networkError(message: 'Network');

        final result = error.map(
          notFound: (_) => 'notFound',
          databaseError: (_) => 'databaseError',
          validationError: (_) => 'validationError',
          networkError: (_) => 'networkError',
          genericError: (_) => 'genericError',
        );

        expect(result, 'networkError');
      });

      test('should map to correct type for genericError', () {
        const error = TaskRepositoryErrors.genericError(message: 'Generic');

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
