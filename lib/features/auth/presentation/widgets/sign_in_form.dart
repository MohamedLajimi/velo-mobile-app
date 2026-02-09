import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/common/widgets/custom_text_form_field.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/utils/auth_validators.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/features/auth/presentation/routes/auth_routes.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _visibilePassword = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _setPasswordVisibility() => setState(() {
    _visibilePassword = !_visibilePassword;
  });

  void _navigateToResetPassword() =>
      context.pushNamed(AuthRoutes.resetPasswordName);

  void _onConnect() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInWithEmailRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: .onUnfocus,
      child: Column(
        children: [
          CustomTextFormField(
            inputType: .emailAddress,
            prefixIcon: CupertinoIcons.mail,
            hintText: context.tr('auth.login.email'),
            controller: _emailController,
            validator: (value) => AuthValidators.email(
              value,
              context.tr('auth.validation.invalid_email'),
            ),
          ),
          16.vSpace,
          CustomTextFormField(
            prefixIcon: CupertinoIcons.lock,
            suffixIcon: _visibilePassword
                ? CupertinoIcons.eye
                : CupertinoIcons.eye_slash,
            isObscureText: !_visibilePassword,
            onTapSuffixIcon: _setPasswordVisibility,
            hintText: context.tr('auth.login.password'),
            controller: _passwordController,
          ),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: TextButton(
              onPressed: _navigateToResetPassword,
              child: Text(context.tr('auth.login.forgot_password')),
            ),
          ),
          16.vSpace,
          BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state is AuthLoading && !state.withGoogle,
            builder: (context, isLoading) => CustomFilledButton(
              isLoading: isLoading,
              text: context.tr('auth.login.login_button'),
              onPressed: _onConnect,
            ),
          ),
        ],
      ),
    );
  }
}
