import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingUiModel {
  final IconData icon;
  final String titleKey;
  final String descKey;

  const OnboardingUiModel({
    required this.icon,
    required this.titleKey,
    required this.descKey,
  });
}

const List<OnboardingUiModel> onboardingSections = [
  OnboardingUiModel(
    icon: CupertinoIcons.car_detailed,
    titleKey: 'onboarding.page1.title',
    descKey: 'onboarding.page1.desc',
  ),
  OnboardingUiModel(
    icon: CupertinoIcons.search,
    titleKey: 'onboarding.page2.title',
    descKey: 'onboarding.page2.desc',
  ),
  OnboardingUiModel(
    icon: Icons.verified_user_rounded,
    titleKey: 'onboarding.page3.title',
    descKey: 'onboarding.page3.desc',
  ),
];
