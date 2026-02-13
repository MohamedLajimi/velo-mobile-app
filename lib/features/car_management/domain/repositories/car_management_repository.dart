import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/common/entities/document_entity.dart';
import 'package:karaba/core/common/models/pagination_response.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/features/car_management/domain/entities/car_form_entity.dart';
import 'package:karaba/features/car_management/domain/usecases/get_owner_cars_use_case.dart';

abstract interface class CarManagementRepository {
  Future<Either<Failure, PaginationResponse<CarEntity>>> getOwnerCars({
    required GetOwnerCarsParams params,
  });

  Future<Either<Failure, CarEntity>> getCarDetails({required String carId});

  Future<Either<Failure, CarEntity>> addCar({required CarFormEntity params});

  Future<Either<Failure, CarEntity>> updateCar({required CarFormEntity params});

  Future<Either<Failure, Unit>> deleteCar({required String carId});

  Future<Either<Failure, List<DocumentEntity>>> getCarDocuments({
    required String carId,
  });
}
