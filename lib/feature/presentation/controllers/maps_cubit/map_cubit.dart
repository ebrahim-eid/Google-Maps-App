import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/feature/data/data_source/places_direction.dart';
import 'package:flutter_maps/feature/data/models/place_details_model.dart';
import 'package:flutter_maps/feature/data/models/places_predictions_model.dart';
import 'package:flutter_maps/feature/presentation/controllers/maps_cubit/map_states.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/helpers/location_helper/location_helper.dart';
import '../../../data/data_source/places_details.dart';
import '../../../data/data_source/places_predictions.dart';
import '../../../data/models/direction_model.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(MapInitialState());

  static MapCubit get(context) => BlocProvider.of(context);

  Position? position;
  CameraPosition? cameraPosition;

  /// get position
  Future<void> getPosition() async {
    position = await LocationHelper.determinePosition();
    if (position != null) {
      cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        bearing: 0,
        tilt: 0,
        zoom: 17,
      );
      emit(GetPositionSuccessState());
    } else {
      print('No known position available');
      emit(GetPositionErrorState());
    }
  }

  /// get places prediction
  List<PlacesModel> predictList = [];
  Future<void> getPlacesPredictions(
      {required String placeName, required String sessionToken}) async {
    emit(PlacesPredictionLoadingState());
    try {
      predictList = await PlacesPredictions().getPlacesPredictions(
        placeName: placeName,
        sessionToken: sessionToken,
      );
      print(predictList[1].description);
      emit(PlacesPredictionSuccessState());
    } catch (error) {
      emit(PlacesPredictionErrorState(error.toString()));
    }
  }

  /// get places details
  PlaceDetailsModel? placeDetailsModel;
  Future<void> getPlacesDetails(
      {required String placeId, required String sessionToken}) async {
    emit(PlacesDetailsLoadingState());
    await PlacesDetails()
        .getPlacesDetails(placeId: placeId, sessionToken: sessionToken)
        .then((value) {
      placeDetailsModel = value;
      print(placeDetailsModel!.lat);
      emit(PlacesDetailsSuccessState());
    }).catchError((error) {
      emit(PlacesDetailsErrorState(error.toString()));
    });
  }

  Set<Marker> markers = {};
  PlacesModel? placesModel;

  /// add markers
  void addMarkers(Marker marker) {
    markers.add(marker);
    emit(UpdateMarkerState());
  }

  /// places directions
  DirectionModel? directionModel;
  late LatLngBounds bounds;
  late List<PointLatLng> polyLinesPoints;
  Future<void> getPlacesDirection(
      {required LatLng origin, required LatLng destination}) async {
    emit(PlacesDirectionsLoadingState());
    await PlacesDirection()
        .getPlacesDirection(origin: origin, destination: destination)
        .then((value) {
      directionModel = value;
      bounds = LatLngBounds(
        northeast: LatLng(directionModel!.northeast['lat'],directionModel!.northeast['lng']),
          southwest: LatLng(directionModel!.southwest['lat'],directionModel!.southwest['lng']),
         );
      polyLinesPoints =PolylinePoints().decodePolyline(directionModel!.overviewPolyline);
      emit(PlacesDirectionsSuccessState());
    }).catchError((error) {
      print('_>>>>>>>>>>>>>>>>>>>${error.toString()}');
      emit(PlacesDirectionsErrorState(error.toString()));
    });
  }

  /// Time and place markers
  bool isSearchedPlaceMarkerClicked = false;
  bool isTimeDistanceVisible = false;
  bool progressInd=false;
  
  

  void updateScreenStateToShowTimeDistanceLabels() {
    isSearchedPlaceMarkerClicked = true;
    isTimeDistanceVisible = true;
    emit(ShowTimeDistanceLabelsState());
  }

  void updateScreenStateToRemoveTimeDistanceLabels() {
    isTimeDistanceVisible = false;
    emit(RemoveTimeDistanceLabelsState());
  }
  
  /// Clear markers
  void clearMarkerState(){
    markers.clear();
    emit(ClearMarkerState());
  }

  /// sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value){
      emit(SignOutState());
    }).catchError((error){
      emit(SignOutErrorState());
    });
  }

}
