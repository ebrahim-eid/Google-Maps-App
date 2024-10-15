class DirectionModel{
  final Map<String,dynamic> northeast;
  final Map<String,dynamic> southwest;
  final String distance;
  final String duration;
  final String overviewPolyline;

  DirectionModel({required this.northeast,
    required this.southwest,
    required this.distance,
    required this.duration,
    required this.overviewPolyline
  });

  factory DirectionModel.fromJson(json){
    return DirectionModel(
        northeast: json['routes'][0]['bounds']['northeast'],
        southwest: json['routes'][0]['bounds']['southwest'],
        distance: json['routes'][0]['legs'][0]['distance']['text'],
        duration: json['routes'][0]['legs'][0]['duration']['text'],
        overviewPolyline: json['routes'][0]['overview_polyline']['points']
    );
  }
}