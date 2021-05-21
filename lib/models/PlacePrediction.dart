class PlacePrediction {
  String secondary_text;
  String main_text;
  String place_id;

  PlacePrediction(
      {required this.secondary_text,
      required this.main_text,
      required this.place_id});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      placeFromJson(json);
}

PlacePrediction placeFromJson(Map<String, dynamic> json) {
  return PlacePrediction(
      secondary_text: json["structured_formatting"]["secondary_text"],
      main_text: json["structured_formatting"]["main_text"],
      place_id: json["place_id"]);
}
