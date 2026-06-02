import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';

/// Contract for every domain use case.
///
/// [Type] is the success return type.
/// [Params] is the input parameter object (use [NoParams] when none needed).
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Placeholder for use cases that require no input parameters.
final class NoParams {
  const NoParams();
}
