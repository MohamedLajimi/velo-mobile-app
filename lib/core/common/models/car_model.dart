import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/common/enums/car_feature.dart';
import 'package:karaba/core/common/enums/car_status.dart';
import 'package:karaba/core/common/enums/currency.dart';
import 'package:karaba/core/common/enums/fuel_type.dart';
import 'package:karaba/core/common/enums/transmission.dart';
import 'package:karaba/core/common/models/car_location_model.dart';
import 'package:karaba/core/common/models/user_model.dart';

class CarModel extends CarEntity {
  const CarModel({
    required super.id,
    required super.ownerId,
    super.owner,
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
    required super.status,
    super.rejectionReason,
    required super.location,
    required super.rate,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      owner: json['owner'] != null
          ? UserModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      fuelType: FuelType.fromMap(json['fuelType'] as String?),
      transmission: Transmission.fromMap(json['transmission'] as String?),
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      currency: Currency.fromMap(json['currency'] as String?),
      seats: json['seats'] as int,
      features: (json['features'] as List<dynamic>)
          .map((e) => CarFeature.fromMap(e as String?))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: CarStatus.fromMap(json['status'] as String?),
      rejectionReason: json['rejectionReason'] as String?,
      location: CarLocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      rate: (json['rate'] as num).toDouble(),
    );
  }
}
