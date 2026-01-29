import 'package:equatable/equatable.dart';
import 'package:karaba/core/enums/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final UserRole role;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? avatarUrl;
  final String? licenceUrl;
  final bool isVerified;
  final double rate;
  final int reviewCount;

  const UserEntity({
    required this.id,
    required this.role,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl,
    this.licenceUrl,
    this.isVerified = false,
    this.rate = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [id, email, role, isVerified];
}
