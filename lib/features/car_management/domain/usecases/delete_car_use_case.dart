import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/car_management/domain/repositories/car_management_repository.dart';

class DeleteCarUseCase implements UseCase<Unit, String> {
  final CarManagementRepository _repository;

  const DeleteCarUseCase({required CarManagementRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Unit>> call(String carId) =>
      _repository.deleteCar(carId: carId);
}
