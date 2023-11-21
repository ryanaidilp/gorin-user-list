class BaseException implements Exception {
  const BaseException(this.message);
  final String message;
}

class UserNotFoundException extends BaseException {
  UserNotFoundException() : super('User credentials not found!');
}

class AuthenticationException extends BaseException {
  AuthenticationException()
      : super(
          'There is something wrong when trying to login!',
        );
}

class DuplicateAccountException extends BaseException {
  DuplicateAccountException()
      : super(
          'An account with the given email is already exist!',
        );
}

class RegistrationException extends BaseException {
  RegistrationException()
      : super(
          'There is something wrong when trying to create your account!',
        );
}
