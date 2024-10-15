class PlacesApiDetailsException implements Exception {
  final String message;
  PlacesApiDetailsException(this.message);

  @override
  String toString() => 'PlacesApiDetailsException: $message';
}