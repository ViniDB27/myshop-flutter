class HttpErrors implements Exception {
  final String message;
  final int statusCode;

  HttpErrors({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return this.message;
  }
}