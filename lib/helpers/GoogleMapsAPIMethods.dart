import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/configMaps.dart';
import 'package:riderapp/dataHandler/appData.dart';
import 'package:riderapp/helpers/GoogleMapsAPI.dart';
import 'package:riderapp/models/Address.dart';
import 'package:riderapp/models/DirectionDetail.dart';

class GoogleMapsAPIMethods {
  static Future<String> searchCoordinatesAddress(
      Position position, context) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}=$mapKey";

    var response = await GoogleMapsAPI.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address userAddress = new Address(
          formattedAddress: "",
          placeName: placeAddress,
          placeId: "",
          latitude: position.latitude,
          longitude: position.longitude);

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetail> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng destinationPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
    var resp = await GoogleMapsAPI.getRequest(directionUrl);
    if (resp == "failed") {
      return new DirectionDetail(distanceValue: 0, durationValue: 0, distanceText: "", durationText: "", encodedPoints: "");
    }

    DirectionDetail directionDetail = new DirectionDetail(
        distanceValue: resp["routes"][0]["legs"][0]["distance"]["value"],
        durationValue: resp["routes"][0]["legs"][0]["duration"]["value"],
        distanceText: resp["routes"][0]["legs"][0]["distance"]["text"],
        durationText: resp["routes"][0]["legs"][0]["duration"]["text"],
        encodedPoints: resp["routes"][0]["overview_polyline"]["points"]);

        return directionDetail;
  }

  static int calculateFare(DirectionDetail directionDetail){
    // interms of uSD
    double timeTraveledFare = (directionDetail.durationValue / 60) * 0.20;
    double distanceTraveledFare = (directionDetail.distanceValue / 1000) * 0.20;

    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    double totalLocalAmount = totalFareAmount * 100; //KES

    return totalLocalAmount.truncate();
    
  }
}
