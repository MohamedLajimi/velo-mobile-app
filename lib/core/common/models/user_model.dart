import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.role,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    super.avatarUrl,
    required super.idCardUrl,
    super.isVerified,
    required super.hasFinishedProfile,
    super.rate,
    super.reviewCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    role: UserRole.values.byName(json['role'] ?? 'renter'),
    fullName: json['full_name'] ?? '',
    email: json['email'] as String,
    phoneNumber: json['phone_number'] ?? '',
    avatarUrl: json['avatar_url'] as String?,
    idCardUrl: json['id_card_url'] ?? '',
    isVerified: json['is_verified'] ?? false,
    hasFinishedProfile: json['has_finished_profile'] ?? false,
    rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    reviewCount: json['review_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.name,
    'full_name': fullName,
    'email': email,
    'phone_number': phoneNumber,
    'avatar_url': avatarUrl,
    'id_card_url': idCardUrl,
    'is_verified': isVerified,
    'has_finished_profile': hasFinishedProfile,
    'rate': rate,
    'review_count': reviewCount,
  };
}
