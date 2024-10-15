class PlacesDirections implements Exception {
  final String message;
  PlacesDirections(this.message);

  @override
  String toString() => 'Places Directions: $message';
}