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
