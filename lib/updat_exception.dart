class UpdatException implements Exception {
  const UpdatException(this.message);

  final String message;

  @override
  String toString() => 'UpdatException: $message';
}
