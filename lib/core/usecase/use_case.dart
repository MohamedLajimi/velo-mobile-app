import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';

abstract interface class UseCase<SuccessType,Params>{
  Future<Either<Failure,SuccessType>>call(Params params);
}

abstract interface class NoParamsUseCase<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}