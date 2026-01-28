import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:karaba/features/onboarding/presentation/onboarding_helper.dart';
import 'package:karaba/features/onboarding/presentation/widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPressed() {
    if (_currentPage < onboardingSections.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    context.read<OnboardingBloc>().add(OnboardingFinished());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.goNamed('login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: _finish,
              child: Text(context.tr('onboarding.skip')),
            ),
          ],
        ),
        body: Padding(
          padding: .symmetric(horizontal: 16, vertical: 24),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() {
              _currentPage = value;
            }),
            itemCount: onboardingSections.length,
            itemBuilder: (context, index) => OnboardingItem(
              model: onboardingSections[index],
              currentIndex: _currentPage,
              onPressed: _onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
