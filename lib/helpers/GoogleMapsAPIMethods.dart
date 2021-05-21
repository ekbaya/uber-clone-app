import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/configMaps.dart';
import 'package:riderapp/dataHandler/appData.dart';
import 'package:riderapp/helpers/GoogleMapsAPI.dart';
import 'package:riderapp/models/Address.dart';

class GoogleMapsAPIMethods{
  static Future<String> searchCoordinatesAddress(Position position, context) async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}=$mapKey";

    var response = await GoogleMapsAPI.getRequest(url);

    if(response != "failed"){
      placeAddress = response["results"][0]["formatted_address"];

      Address userAddress = new Address(formattedAddress: "", placeName: placeAddress, placeId: "", latitude: position.latitude, longitude: position.longitude);

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userAddress);

    }

    return placeAddress;
  }
}