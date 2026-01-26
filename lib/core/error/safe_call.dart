import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:retry/retry.dart';
import 'dart:async';

typedef FailureHandler = Failure Function(dynamic e);

class SafeCall {
  static Future<Either<Failure, T>> execute<T>({
    required Future<T> Function() action,
    required FailureHandler onException,
    bool enableRetry = false,
  }) async {
    try {
      final T result;

      if (enableRetry) {
        result = await retry(
          () => action().timeout(const Duration(seconds: 10)),
          retryIf: (e) => _isTransientError(e),
          maxAttempts: 3,
          delayFactor: const Duration(milliseconds: 500),
        );
      } else {
        result = await action();
      }

      return right(result);
    } catch (e) {
      return left(onException(e));
    }
  }

  static bool _isTransientError(dynamic e) {
    return e is TimeoutException ||
        e.toString().contains('SocketException') ||
        e.toString().contains('Connection failed');
  }
}
