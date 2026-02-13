import 'package:karaba/core/common/entities/car_location_entity.dart';

class CarLocationModel extends CarLocationEntity {
  const CarLocationModel({
    required super.address,
    required super.city,
    required super.lat,
    required super.lng,
  });

  factory CarLocationModel.fromJson(Map<String, dynamic> json) {
    return CarLocationModel(
      address: json['address'] as String,
      city: json['city'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
