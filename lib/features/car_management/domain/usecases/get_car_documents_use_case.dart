import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/document_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/car_management/domain/repositories/car_management_repository.dart';

class GetCarDocumentsUseCase implements UseCase<List<DocumentEntity>, String> {
  final CarManagementRepository _repository;

  const GetCarDocumentsUseCase({required CarManagementRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<DocumentEntity>>> call(String carId) =>
      _repository.getCarDocuments(carId: carId);
}
