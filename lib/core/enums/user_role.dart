enum UserRole {
  renter,
  owner,
  admin;

  String get displayName => 'enums.user_role.$name';

  bool get isRenter => this == UserRole.renter;
  bool get isOwner => this == UserRole.owner;
  bool get isAdmin => this == UserRole.admin;
}
