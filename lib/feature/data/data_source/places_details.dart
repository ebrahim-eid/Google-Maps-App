import 'package:dio/dio.dart';

import '../../../core/constants/constants.dart';
import '../../../error/places_details_exception.dart';
import '../models/place_details_model.dart';


class PlacesDetails{
  final dio =Dio();
  /// get places details
  Future<PlaceDetailsModel> getPlacesDetails({
    required String placeId,
    required String sessionToken
  }) async{
    Map<String, dynamic> query = {
      'place_id': placeId,
      'fields': "geometry",
      "key": AppConstants.googleApiKey,
      "sessiontoken": sessionToken
    };

    Response response= await dio.get(AppConstants.placesDetailsBaseUrl,queryParameters: query);
    try{
      if(response.statusCode==200){
        PlaceDetailsModel placeDetailsModel = PlaceDetailsModel.fromJson(response.data);
        return placeDetailsModel;
      }else{
        throw PlacesApiDetailsException("Places details ${response.statusCode} ${response.statusMessage}");
      }
    }catch(error){
      if (error is DioException) {
        throw PlacesApiDetailsException('Places Details => Dio Exception: ${error.message}');
      } else {
        throw PlacesApiDetailsException('Places Details => Unexpected error: $error');
      }
    }
  }

}