import 'package:google_sign_in/google_sign_in.dart';
import 'package:karaba/core/error/core_exception_mapper.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthExceptionMapper {
  static Failure map(dynamic e) {
    if (e is AuthException) {
      return AuthFailure(_getAuthMessage(e.code));
    }
    if (e is GoogleSignInException) {
      return AuthFailure(_getGoogleMessage(e));
    }

    return CoreExceptionMapper.map(e);
  }

  static String _getAuthMessage(String? code) {
    switch (code) {
      case 'invalid_credentials':
        return 'auth.errors.invalid_credentials';
      case 'user_not_found':
        return 'auth.errors.user_not_found';
      case 'email_exists':
        return 'auth.errors.email_exists';
      default:
        return 'auth.errors.generic_auth';
    }
  }

  static String _getGoogleMessage(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'auth.error.canceled';
      case GoogleSignInExceptionCode.interrupted:
        return 'auth.error.interrupted';
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'auth.error.config_error';
      case GoogleSignInExceptionCode.userMismatch:
        return 'auth.error.user_mismatch';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'auth.error.ui_unavailable';
      case GoogleSignInExceptionCode.unknownError:
      default:
        return 'auth.error.google_unknown';
    }
  }
}
