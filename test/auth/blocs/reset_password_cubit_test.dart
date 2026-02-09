import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:karaba/features/auth/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late ResetPasswordCubit cubit;
  late MockResetPasswordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockResetPasswordUseCase();
    cubit = ResetPasswordCubit(resetPasswordUseCase: mockUseCase);
  });

  tearDown(() => cubit.close());

  group('ResetPasswordCubit', () {
    const tEmail = 'test@karaba.com';

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits [loading, success with countdown] when link sent successfully',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ResetPasswordState(status: ResetPasswordStatus.loading),
        const ResetPasswordState(status: ResetPasswordStatus.success, resendCountdown: 60),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits [isResending: true] when resending from success state',
      seed: () => const ResetPasswordState(status: ResetPasswordStatus.success),
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ResetPasswordState(status: ResetPasswordStatus.success, isResending: true),
        const ResetPasswordState(status: ResetPasswordStatus.success, resendCountdown: 60, isResending: false),
      ],
    );

    test('countdown decreases state every second', () {
      fakeAsync((async) {
        when(() => mockUseCase.call(any())).thenAnswer((_) async => const Right(unit));
        
        cubit.sendResetLink(tEmail);
        async.elapse(const Duration(milliseconds: 10));
        
        expect(cubit.state.resendCountdown, 60);
        
        async.elapse(const Duration(seconds: 1));
        expect(cubit.state.resendCountdown, 59);
        
        async.elapse(const Duration(seconds: 59));
        expect(cubit.state.resendCountdown, 0);
      });
    });

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits error state when usecase fails',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer((_) async => const Left(ServerFailure('SMTP Error')));
        return cubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ResetPasswordState(status: ResetPasswordStatus.loading),
        const ResetPasswordState(status: ResetPasswordStatus.error, errorMessage: 'SMTP Error'),
      ],
    );
  });
}