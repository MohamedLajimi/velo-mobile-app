
import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/car_management/domain/repositories/car_management_repository.dart';

class GetCarDetailsUseCase implements UseCase<CarEntity, String> {
  final CarManagementRepository _repository;

  const GetCarDetailsUseCase({required CarManagementRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CarEntity>> call(String carId) =>
      _repository.getCarDetails(carId: carId);
}
