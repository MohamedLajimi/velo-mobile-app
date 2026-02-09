import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/core/common/widgets/custom_indicator.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/features/onboarding/presentation/onboarding_helper.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingUiModel model;
  final int currentIndex;
  final VoidCallback onPressed;
  const OnboardingItem({
    super.key,
    required this.model,
    required this.currentIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisAlignment: .center,
      children: [
        Icon(model.icon, size: 120, color: context.colorScheme.primary)
            .animate(key: ValueKey(model.icon))
            .fade(duration: 500.ms)
            .scale(delay: 100.ms, curve: Curves.elasticOut),

        Text(
          model.titleKey.tr(),
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: .center,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

        Text(
          model.descKey.tr(),
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
        10.vSpace,
        CustomIndicator(
          itemCount: onboardingSections.length,
          currentIndex: currentIndex,
        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
        CustomFilledButton(
          text: currentIndex < onboardingSections.length - 1
              ? context.tr('onboarding.next')
              : context.tr('onboarding.get_started'),
          onPressed: onPressed,
        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
      ],
    );
  }
}
