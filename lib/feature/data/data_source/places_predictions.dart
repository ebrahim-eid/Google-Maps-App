import 'package:dio/dio.dart';
import 'package:flutter_maps/error/places_exception.dart';

import '../../../core/constants/constants.dart';
import '../models/places_predictions_model.dart';


class PlacesPredictions {
  final dio = Dio();
  /// get places predictions
  Future<List<PlacesModel>> getPlacesPredictions(
      {required String placeName, required String sessionToken}) async {
    Map<String, dynamic> query = {
      'input': placeName,
      'types': "address",
      'components': "country:eg",
      "key": AppConstants.googleApiKey,
      "sessiontoken": sessionToken
    };
    Response response = await dio.get(AppConstants.placesBaseUrl, queryParameters: query);
    try {
      if (response.statusCode == 200) {
        List<dynamic> predictionsJson = response.data['predictions'];
        List<PlacesModel> predictList =
            predictionsJson.map((json) => PlacesModel.fromJson(json)).toList();
        return predictList;
      } else {
        throw PlacesApiException(
            'Places predictions ${response.statusCode} , ${response.statusMessage}');
      }
    } catch (error) {
      if (error is DioException) {
        throw PlacesApiException('Dio Exception: ${error.message}');
      } else {
        throw PlacesApiException('Unexpected error: $error');
      }
    }
  }

}
