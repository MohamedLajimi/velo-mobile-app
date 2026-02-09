import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/common/widgets/custom_text_form_field.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/features/auth/presentation/widgets/auth_header.dart';
import 'package:karaba/features/auth/presentation/widgets/id_card_uploader.dart';
import 'package:karaba/features/auth/presentation/widgets/user_role_selector.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userId;
  const CompleteProfileScreen({super.key, required this.userId});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();

  String? _idCardPath;
  UserRole _selectedRole = UserRole.renter;

  bool _showIdCardError = false;

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
  }

  void _onCompleteProfile() {
    debugPrint(widget.userId);

    final isFormValid = _formKey.currentState!.validate();

    final isIdCardValid = _idCardPath != null;

    setState(() {
      _showIdCardError = !isIdCardValid;
    });

    if (!isFormValid || !isIdCardValid) {
      return;
    }

    context.read<AuthBloc>().add(
      CompleteProfileRequested(
        userId: widget.userId,
        role: _selectedRole,
        phoneNumber: _phoneController.text,
        idCardPath: _idCardPath!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackbar.show(
            context,
            message: context.tr(state.message),
            type: SnackBarType.error,
          );
        }
        if (state is AuthSuccess) {
          context.read<UserCubit>().updateUser(state.user);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const .fromLTRB(16, 16, 16, 48),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AuthHeader(
                  title: context.tr('auth.complete_profile.title'),
                  subtitle: context.tr('auth.complete_profile.subtitle'),
                ),
                32.vSpace,
                CustomTextFormField(
                  inputType: .phone,
                  prefixIcon: CupertinoIcons.phone,
                  hintText: context.tr('auth.signup.phone'),
                  controller: _phoneController,
                ),
                16.vSpace,
                UserRoleSelector(
                  selectedRole: _selectedRole,
                  onRoleChanged: (value) => _selectedRole = value,
                ),
                16.vSpace,

                IdCardUploader(
                  initialPath: _idCardPath,
                  onChanged: (value) => setState(() {
                    _idCardPath = value;
                    _showIdCardError = value == null;
                  }),
                ),
                if (_showIdCardError) ...[
                  8.vSpace,
                  Text(
                    context.tr('auth.validation.id_card_required'),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ],

                24.vSpace,
                BlocSelector<AuthBloc, AuthState, bool>(
                  selector: (state) => state is AuthLoading,
                  builder: (context, isLoading) => CustomFilledButton(
                    text: context.tr('auth.complete_profile.submit_button'),
                    isLoading: isLoading,
                    onPressed: _onCompleteProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
