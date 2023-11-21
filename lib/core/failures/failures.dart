class Failure {
  const Failure(this.message);

  final String message;
}

class DatabaseFailure extends Failure {
  DatabaseFailure()
      : super(
          'There is something wrong when try to access storage!',
        );
}

class RegistrationFailure extends Failure {
  RegistrationFailure()
      : super(
          'There is something wrong when try to register!',
        );
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure()
      : super(
          'There is something wrong when try to login!',
        );
}

class LogoutFailure extends Failure {
  LogoutFailure()
      : super(
          'There is something wrong when try to login!',
        );
}
