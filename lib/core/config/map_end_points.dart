class MapEndpoints {
  /// Base URL for Google Maps / Places APIs.
  static const String baseUrl = "https://maps.googleapis.com";

  static String placeAutoComplete({
    required String search,
    required String uuid,
    required String mapKey,
  }) =>
      "/maps/api/place/autocomplete/json"
      "?key=$mapKey&input=$search&sessiontoken=$uuid";

  static String placeTextSearch({
    required String search,
    required String mapKey,
  }) =>
      "/maps/api/place/textsearch/json"
      "?query=$search&key=$mapKey";

  static String mapPlaceDetails({
    required String placeId,
    required String mapKey,
  }) =>
      "/maps/api/place/details/json"
      "?place_id=$placeId"
      "&fields=name,formatted_address,geometry,place_id"
      "&key=$mapKey";

  static String getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    required String mapKey,
  }) =>
      "/maps/api/directions/json"
      "?origin=$originLat,$originLng"
      "&destination=$destinationLat,$destinationLng"
      "&key=$mapKey";
}

