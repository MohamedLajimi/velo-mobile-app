import 'package:equatable/equatable.dart';
import 'package:karaba/core/enums/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final UserRole role;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? avatarUrl;
  final String idCardUrl;
  final bool isVerified;
  final bool hasFinishedProfile;
  final double rate;
  final int reviewCount;

  const UserEntity({
    required this.id,
    required this.role,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl,
    required this.idCardUrl,
    this.isVerified = false,
    required this.hasFinishedProfile,
    this.rate = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    role,
    fullName,
    email,
    phoneNumber,
    avatarUrl,
    idCardUrl,
    isVerified,
    hasFinishedProfile,
    rate,
    reviewCount,
  ];
}
