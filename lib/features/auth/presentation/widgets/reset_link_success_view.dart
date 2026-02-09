import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/features/auth/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';

class ResetLinkSuccessView extends StatelessWidget {
  final String email;
  const ResetLinkSuccessView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return SingleChildScrollView(
      padding: const .all(16),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        children: [
          const Icon(Icons.mark_email_read_outlined, size: 80),
          24.vSpace,
          Text(
            context.tr('auth.reset_password.success_title'),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          16.vSpace,
          RichText(
            textAlign: .center,
            text: TextSpan(
              style: textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: context.tr('auth.reset_password.success_message_part1'),
                ),
                TextSpan(
                  text: email,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: context.tr('auth.reset_password.success_message_part2'),
                ),
              ],
            ),
          ),
          24.vSpace,
          Text(
            context.tr('auth.reset_password.resend_label'),
            style: context.textTheme.bodyLarge,
            textAlign: .center,
          ),
          BlocSelector<ResetPasswordCubit, ResetPasswordState, (int, bool)>(
            selector: (state) {
              return (state.resendCountdown, state.isResending);
            },
            builder: (context, data) {
              final count = data.$1;
              final isResending = data.$2;
              final canResend = count == 0 && !isResending;

              return TextButton(
                onPressed: canResend
                    ? () => context.read<ResetPasswordCubit>().sendResetLink(
                        email,
                      )
                    : null,
                child: isResending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        canResend
                            ? context.tr('auth.reset_password.resend_button')
                            : context.tr(
                                'auth.reset_password.resend_wait',
                                namedArgs: {'seconds': count.toString()},
                              ),
                        style: TextStyle(
                          color: canResend
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
          32.vSpace,
          CustomFilledButton(
            text: context.tr('auth.reset_password.back_to_login'),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
