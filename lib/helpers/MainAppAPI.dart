
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/appConfig.dart';
import 'package:riderapp/dataHandler/appData.dart';
import 'package:riderapp/helpers/GoogleMapsRepository.dart';
import 'package:riderapp/main.dart';
import 'package:riderapp/models/Address.dart';
import 'package:riderapp/models/DirectionDetail.dart';
import 'package:riderapp/models/User.dart';

class MainAppAPI {
  static Future<String> searchCoordinatesAddress(
      Position position, context) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}=$mapKey";

    var response = await GoogleMapsRepository.getRequest(url);

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
    var resp = await GoogleMapsRepository.getRequest(directionUrl);
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

  static void getCurrentOnlineUserInfo()async{
    firebaseUser = FirebaseAuth.instance.currentUser!;
    String userId = firebaseUser.uid;

    userRef.child(userId).once().then((DataSnapshot snapshot){
        if(snapshot.value != null){
          currentUser = CurrentUser.fromSnapshot(snapshot);
        }
    });
  }
}
