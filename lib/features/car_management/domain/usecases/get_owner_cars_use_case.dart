import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/common/enums/car_status.dart';
import 'package:karaba/core/common/enums/transmission.dart';
import 'package:karaba/core/common/models/pagination_response.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/car_management/domain/repositories/car_management_repository.dart';

class GetOwnerCarsUseCase
    implements UseCase<PaginationResponse, GetOwnerCarsParams> {
  final CarManagementRepository _carManagementRepository;

  const GetOwnerCarsUseCase({required CarManagementRepository repository})
    : _carManagementRepository = repository;

  @override
  Future<Either<Failure, PaginationResponse<CarEntity>>> call(
    GetOwnerCarsParams params,
  ) => _carManagementRepository.getOwnerCars(params: params);
}

class GetOwnerCarsParams extends Equatable {
  final int take;
  final int skip;
  final String? brand;
  final String? model;
  final String? city;
  final Transmission? transmission;
  final double? minPrice;
  final double? maxPrice;
  final CarStatus? status;
  final bool? availableOnly;

  const GetOwnerCarsParams({
    this.take = 10,
    this.skip = 0,
    this.brand,
    this.model,
    this.city,
    this.transmission,
    this.minPrice,
    this.maxPrice,
    this.status,
    this.availableOnly,
  });

  GetOwnerCarsParams copyWith({
    int? take,
    int? skip,
    String? brand,
    String? model,
    String? city,
    Transmission? transmission,
    double? minPrice,
    double? maxPrice,
    CarStatus? status,
    bool? availableOnly,
  }) => GetOwnerCarsParams(
    take: take ?? this.take,
    skip: skip ?? this.skip,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    city: city ?? this.city,
    transmission: transmission ?? this.transmission,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    status: status ?? this.status,
    availableOnly: availableOnly ?? this.availableOnly,
  );

  bool get hasFilters =>
      brand != null ||
      model != null ||
      city != null ||
      transmission != null ||
      minPrice != null ||
      maxPrice != null ||
      status != null;

  @override
  List<Object?> get props => [
    take,
    skip,
    brand,
    model,
    city,
    transmission,
    minPrice,
    maxPrice,
    status,
    availableOnly,
  ];
}
