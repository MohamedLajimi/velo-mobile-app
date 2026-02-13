import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/car_management/domain/entities/car_form_entity.dart';
import 'package:karaba/features/car_management/domain/repositories/car_management_repository.dart';

class UpdateCarUseCase implements UseCase<CarEntity, CarFormEntity> {
  final CarManagementRepository _repository;

  const UpdateCarUseCase({required CarManagementRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CarEntity>> call(CarFormEntity params) async =>
      params.id != null
      ? await _repository.updateCar(params: params)
      : Left(ValidationFailure('car_management.error.invalid_id'));
}
