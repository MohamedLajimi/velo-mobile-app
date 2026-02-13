import 'package:karaba/features/car_management/domain/entities/car_form_entity.dart';

class CarFormModel extends CarFormEntity {
  const CarFormModel({
    super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.fuelType,
    required super.transmission,
    required super.pricePerDay,
    required super.currency,
    required super.seats,
    required super.features,
    required super.images,
    required super.documents,
    required super.location,
    required super.status,
  });

  factory CarFormModel.fromEntity(CarFormEntity entity) => CarFormModel(
    id: entity.id,
    brand: entity.brand,
    model: entity.model,
    year: entity.year,
    fuelType: entity.fuelType,
    transmission: entity.transmission,
    pricePerDay: entity.pricePerDay,
    currency: entity.currency,
    seats: entity.seats,
    features: entity.features,
    images: entity.images,
    documents: entity.documents,
    location: entity.location,
    status: entity.status,
  );

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'fuel_type': fuelType.name,
      'transmission': transmission.name,
      'price_per_day': pricePerDay,
      'currency': currency.name,
      'seats': seats,
      'features': features.map((e) => e.name).toList(),
      'status': status,
    };
  }
}
