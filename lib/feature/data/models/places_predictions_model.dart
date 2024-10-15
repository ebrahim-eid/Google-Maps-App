class PlacesModel {
  final String placeId;
  final String description;

  PlacesModel({required this.placeId, required this.description});

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
        placeId: json["place_id"],
        description: json["description"]
    );
  }
}
