class PlaceDetailsModel{
  final double lat;
  final double lng;

  PlaceDetailsModel({required this.lat, required this.lng});

  factory PlaceDetailsModel.fromJson(json){
    var jsonData=json['result']['geometry']['location'];
    return PlaceDetailsModel(
        lat: jsonData['lat'],
        lng: jsonData['lng']
    );
  }
}