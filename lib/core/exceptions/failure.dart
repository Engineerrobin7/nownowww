class Failure {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}
