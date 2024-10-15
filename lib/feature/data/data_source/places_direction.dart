import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../error/direction_exception.dart';
import '../models/direction_model.dart';

class PlacesDirection{
  final dio = Dio();
  /// get places predictions
  Future<DirectionModel> getPlacesDirection(
      {required LatLng origin, required LatLng destination}) async {
    Map<String, dynamic> query = {
      'origin': "${origin.latitude},${origin.longitude}",
      'destination': "${destination.latitude},${destination.longitude}",
      "key": AppConstants.googleApiKey,
    };
    Response response = await dio.get(
        AppConstants.placesDirectionsBaseUrl, queryParameters: query);
    try {
      if (response.statusCode == 200) {
        DirectionModel directionModel=DirectionModel.fromJson(response.data);
        print("===================================>${directionModel.distance}");
        return directionModel;
      } else {
        throw PlacesDirections(
            'Places predictions ${response.statusCode} , ${response.statusMessage}');
      }
    } catch (error) {
      if (error is DioException) {
        throw PlacesDirections('Dio Exception: ${error.message}');
      } else {
        throw PlacesDirections('Unexpected error: $error');
      }
    }
  }

}