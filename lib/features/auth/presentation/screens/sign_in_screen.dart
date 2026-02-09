import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';
import 'package:karaba/core/common/widgets/custom_social_button.dart';
import 'package:karaba/core/common/widgets/language_dropdown_selector.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/features/auth/presentation/routes/auth_routes.dart';
import 'package:karaba/features/auth/presentation/widgets/auth_footer.dart';
import 'package:karaba/features/auth/presentation/widgets/auth_header.dart';
import 'package:karaba/features/auth/presentation/widgets/continue_with_widget.dart';
import 'package:karaba/features/auth/presentation/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [const LanguageDropdownSelector()]),
      body: BlocListener<AuthBloc, AuthState>(
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
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              AuthHeader(
                title: context.tr('auth.login.title'),
                subtitle: context.tr('auth.login.subtitle'),
              ),
              32.vSpace,
              const SignInForm(),
              32.vSpace,
              const ContinueWithWidget(),
              16.vSpace,
              SocialAuthButton(
                text: context.tr('auth.login.google_signin'),
                iconPath: 'assets/images/google_logo.png',
                onPressed: () =>
                    context.read<AuthBloc>().add(SignInWithGoogleRequested()),
              ),
              32.vSpace,
              AuthFooter(
                firstText: context.tr('auth.login.no_account'),
                secondText: context.tr('auth.login.signup_link'),
                onTextPressed: () => context.pushNamed(AuthRoutes.signupName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
