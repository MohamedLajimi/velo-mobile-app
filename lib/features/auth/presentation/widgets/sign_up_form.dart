import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/widgets/custom_avatar_selector.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/common/widgets/custom_text_form_field.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/core/utils/auth_validators.dart';
import 'package:karaba/features/auth/presentation/widgets/id_card_uploader.dart';
import 'package:karaba/features/auth/presentation/widgets/user_role_selector.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();

  String? _avatarPath;
  String? _idCardPath;
  UserRole _selectedRole = UserRole.renter;

  final ValueNotifier<bool> _visibilePassword = ValueNotifier(false);

  bool _showIdCardError = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _visibilePassword.dispose();
  }

  void _onCreateAccount() {
    final isFormValid = _formKey.currentState!.validate();

    final isIdCardValid = _idCardPath != null;

    setState(() {
      _showIdCardError = !isIdCardValid;
    });

    if (!isFormValid || !isIdCardValid) {
      return;
    }

    context.read<AuthBloc>().add(
      SignUpWithEmailRequested(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        phoneNumber: _phoneController.text,
        avatarUrl: _avatarPath,
        idCardUrl: _idCardPath!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('auth.signup.personal'),
            style: context.textTheme.titleMedium,
          ),
          const Divider(),
          Center(
            child: CustomAvatarSelector(
              initialImageUrl: _avatarPath,
              radius: 56,
              onImageChanged: (file) => _avatarPath = file?.path,
              onImageDeleted: () => _avatarPath = null,
            ),
          ),
          16.vSpace,
          CustomTextFormField(
            prefixIcon: CupertinoIcons.person,
            hintText: context.tr('auth.signup.full_name'),
            controller: _fullNameController,
          ),
          16.vSpace,
          CustomTextFormField(
            inputType: .phone,
            prefixIcon: CupertinoIcons.phone,
            hintText: context.tr('auth.signup.phone'),
            controller: _phoneController,
          ),
          24.vSpace,
          Text(
            context.tr('auth.signup.credentials'),
            style: context.textTheme.titleMedium,
          ),
          const Divider(),
          CustomTextFormField(
            inputType: .emailAddress,
            prefixIcon: CupertinoIcons.mail,
            hintText: context.tr('auth.signup.email'),
            controller: _emailController,
            validator: (value) => AuthValidators.email(
              value,
              context.tr('auth.validation.invalid_email'),
            ),
          ),
          16.vSpace,
          ValueListenableBuilder(
            valueListenable: _visibilePassword,
            builder: (context, isVisible, child) => CustomTextFormField(
              prefixIcon: CupertinoIcons.lock,
              suffixIcon: isVisible
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash,
              isObscureText: !isVisible,
              onTapSuffixIcon: () => _visibilePassword.value = !isVisible,
              hintText: context.tr('auth.signup.password'),
              controller: _passwordController,
              validator: (value) => AuthValidators.password(
                value,
                context.tr('auth.validation.invalid_password'),
              ),
            ),
          ),
          24.vSpace,
          Text(
            context.tr('auth.signup.identity'),
            style: context.textTheme.titleMedium,
          ),
          const Divider(),
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
              textAlign: .left,
              context.tr('auth.validation.id_card_required'),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
          24.vSpace,
          BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state is AuthLoading && !state.withGoogle,
            builder: (context, isLoading) => CustomFilledButton(
              text: context.tr('auth.signup.create_account'),
              isLoading: isLoading,
              onPressed: _onCreateAccount,
            ),
          ),
        ],
      ),
    );
  }
}
