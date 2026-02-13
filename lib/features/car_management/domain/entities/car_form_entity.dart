import 'package:equatable/equatable.dart';
import 'package:karaba/core/common/entities/car_location_entity.dart';
import 'package:karaba/core/common/enums/car_feature.dart';
import 'package:karaba/core/common/enums/car_status.dart';
import 'package:karaba/core/common/enums/currency.dart';
import 'package:karaba/core/common/enums/document_type.dart';
import 'package:karaba/core/common/enums/fuel_type.dart';
import 'package:karaba/core/common/enums/transmission.dart';

class CarFormEntity extends Equatable {
  final String? id;
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
  final List<(String, DocumentType)> documents;
  final CarLocationEntity location;
  final CarStatus status;

  const CarFormEntity({
    this.id,
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
    required this.documents,
    required this.location,
    this.status=CarStatus.pending
  });

  bool get isUpdate => id != null;
  bool get isCreate => id == null;

  CarFormEntity copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    FuelType? fuelType,
    Transmission? transmission,
    double? pricePerDay,
    Currency? currency,
    int? seats,
    List<CarFeature>? features,
    List<String>? images,
    List<(String, DocumentType)>? documents,
    CarLocationEntity? location,
    CarStatus? status
  }) => CarFormEntity(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year ?? this.year,
    fuelType: fuelType ?? this.fuelType,
    transmission: transmission ?? this.transmission,
    pricePerDay: pricePerDay ?? this.pricePerDay,
    currency: currency ?? this.currency,
    seats: seats ?? this.seats,
    features: features ?? this.features,
    images: images ?? this.images,
    documents: documents ?? this.documents,
    location: location ?? this.location,
    status: status??this.status
  );

  @override
  List<Object?> get props => [
    id,
    brand,
    model,
    year,
    fuelType,
    transmission,
    pricePerDay,
    currency,
    seats,
    features,
    images,
    documents,
    location,
    status
  ];
}
