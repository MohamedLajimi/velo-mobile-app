import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/common/widgets/custom_text_form_field.dart';
import 'package:karaba/features/auth/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';
import 'package:karaba/features/auth/presentation/widgets/auth_header.dart';
import 'package:karaba/features/auth/presentation/widgets/reset_link_success_view.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = .new();

  void _onSendResetLink() {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().sendResetLink(_emailController.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.error) {
            AppSnackbar.show(
              context,
              message: context.tr(state.errorMessage!),
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state.status == ResetPasswordStatus.success) {
            return ResetLinkSuccessView(email: _emailController.text);
          }
          return SingleChildScrollView(
            padding: const .all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: .onUnfocus,
              child: Column(
                spacing: 24,
                crossAxisAlignment: .start,
                children: [
                  AuthHeader(
                    title: context.tr('auth.reset_password.title'),
                    subtitle: context.tr('auth.reset_password.subtitle'),
                  ),
                  CustomTextFormField(
                    hintText: context.tr('auth.reset_password.email_label'),
                    controller: _emailController,
                    prefixIcon: CupertinoIcons.mail,
                    inputType: TextInputType.emailAddress,
                  ),
                  CustomFilledButton(
                    text: context.tr('auth.reset_password.send_button'),
                    isLoading: state.status == ResetPasswordStatus.loading,
                    onPressed: _onSendResetLink,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
