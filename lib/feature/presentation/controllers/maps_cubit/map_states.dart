abstract class MapStates {}

class MapInitialState extends MapStates {}

/// Position states
class GetPositionSuccessState extends MapStates {}

class GetPositionErrorState extends MapStates {}

/// Places prediction states

class PlacesPredictionLoadingState extends MapStates {}

class PlacesPredictionSuccessState extends MapStates {}

class PlacesPredictionErrorState extends MapStates {
  final String error;

  PlacesPredictionErrorState(this.error);
}

/// places details states

class PlacesDetailsLoadingState extends MapStates {}

class PlacesDetailsSuccessState extends MapStates {}

class PlacesDetailsErrorState extends MapStates {
  final String error;

  PlacesDetailsErrorState(this.error);
}

/// marker state
class UpdateMarkerState extends MapStates {}

/// places directions states

class PlacesDirectionsLoadingState extends MapStates {}

class PlacesDirectionsSuccessState extends MapStates {}

class PlacesDirectionsErrorState extends MapStates {
  final String error;

  PlacesDirectionsErrorState(this.error);
}

/// update screen state to show time and distance labels
class ShowTimeDistanceLabelsState extends MapStates {}

/// update screen state to remove time and distance labels
class RemoveTimeDistanceLabelsState extends MapStates {}

///Clear Marker State
class ClearMarkerState extends MapStates {}


/// sign out
class SignOutState extends MapStates {}
class SignOutErrorState extends MapStates {}