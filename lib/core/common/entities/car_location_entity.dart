import 'package:equatable/equatable.dart';

class CarLocationEntity extends Equatable {
  final String address;
  final String city;
  final double lat;
  final double lng;

  const CarLocationEntity({
    required this.address,
    required this.city,
    required this.lat,
    required this.lng,
  });

  CarLocationEntity copyWith({
    String? address,
    String? city,
    double? lat,
    double? lng,
  }) => CarLocationEntity(
    address: address ?? this.address,
    city: city ?? this.city,
    lat: lat ?? this.lat,
    lng: lng ?? this.lat,
  );

  @override
  List<Object?> get props => [address, city, lat, lng];
}
