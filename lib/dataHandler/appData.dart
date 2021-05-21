import 'package:flutter/material.dart';
import 'package:riderapp/models/Address.dart';

class AppData extends ChangeNotifier{
  late Address userPickUpLocation = new Address(formattedAddress: "", placeName: "", placeId: "", latitude: 0.0, longitude: 0.0);
  late Address userDropOffLocation = new Address(formattedAddress: "", placeName: "", placeId: "", latitude: 0.0, longitude: 0.0);

  void updatePickUpLocationAddress(Address pickUpAddress){
    userPickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address address){
    userDropOffLocation = address;
    notifyListeners();
  }
}