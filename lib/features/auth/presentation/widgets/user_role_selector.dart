import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class UserRoleSelector extends StatefulWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;

  const UserRoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  State<UserRoleSelector> createState() => _UserRoleSelectorState();
}

class _UserRoleSelectorState extends State<UserRoleSelector> {
  UserRole? _selectedRole;
  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        Text(
          context.tr('auth.signup.select_role'),
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        CupertinoSegmentedControl<UserRole>(
          groupValue: _selectedRole,
          selectedColor: context.colorScheme.primary,
          borderColor: context.theme.dividerColor,
          unselectedColor: context.colorScheme.surfaceContainer,
          padding: .zero,
          children: {
            UserRole.renter: Padding(
              padding: const .symmetric(horizontal: 24, vertical: 10),
              child: Text(
                context.tr(UserRole.renter.displayName),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.selectedRole == UserRole.renter
                      ? context.colorScheme.onSurface
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            UserRole.owner: Padding(
              padding: const .symmetric(horizontal: 24, vertical: 10),
              child: Text(
                context.tr(UserRole.owner.displayName),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.selectedRole == UserRole.owner
                      ? context.colorScheme.onSurface
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          },
          onValueChanged: (role) {
            setState(() {
              _selectedRole = role;
              widget.onRoleChanged(role);
            });
          },
        ),
      ],
    );
  }
}
