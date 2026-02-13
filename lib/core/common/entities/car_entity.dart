import 'package:equatable/equatable.dart';
import 'package:karaba/core/common/entities/car_location_entity.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/common/enums/car_feature.dart';
import 'package:karaba/core/common/enums/car_status.dart';
import 'package:karaba/core/common/enums/currency.dart';
import 'package:karaba/core/common/enums/fuel_type.dart';
import 'package:karaba/core/common/enums/transmission.dart';

class CarEntity extends Equatable {
  final String id;
  final String ownerId;
  final UserEntity? owner;
  final String brand;
  final String model;
  final int year;
  final FuelType fuelType;
  final Transmission transmission;
  final double pricePerDay;
  final Currency currency;
  final int seats;
  final List<CarFeature> features;
  final List<String> images;
  final CarStatus status;
  final String? rejectionReason;
  final CarLocationEntity location;
  final double rate;

  const CarEntity({
    required this.id,
    required this.ownerId,
    this.owner,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.pricePerDay,
    required this.currency,
    required this.seats,
    required this.features,
    required this.images,
    required this.status,
    this.rejectionReason,
    required this.location,
    required this.rate,
  });

  @override
  List<Object?> get props => [id, status, images, rejectionReason];
}
