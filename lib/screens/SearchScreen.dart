import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/appConfig.dart';
import 'package:riderapp/dataHandler/appData.dart';
import 'package:riderapp/helpers/GoogleMapsRepository.dart';
import 'package:riderapp/models/Address.dart';
import 'package:riderapp/models/PlacePrediction.dart';
import 'package:riderapp/widgets/Divider.dart';
import 'package:riderapp/widgets/ProgressDialog.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();
  List<PlacePrediction> placepredictions = [];
  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).userPickUpLocation.placeName;
    pickUpTextEditingController.text = placeAddress.toString();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 35.0, top: 30.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Center(
                        child: Text(
                          "Set Drop Off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Pickup Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: destinationTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //tiles for displaying predictions
          (placepredictions.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                        placePrediction: placepredictions[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        AppDivider(),
                    itemCount: placepredictions.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ke";
      var res = await GoogleMapsRepository.getRequest(url);

      if (res == "failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placesList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();

        setState(() {
          placepredictions = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  PredictionTile({Key? key, required this.placePrediction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceAddressDetails(placePrediction.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placePrediction.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        placePrediction.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(message: "Setting up dropoff point please wait...",));


    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var resp = await GoogleMapsRepository.getRequest(placeDetailsUrl);
    print("****************RESP***************");
    print(resp);
    Navigator.of(context).pop();
    if (resp == "failed") {
      return;
    }

    if (resp["status"] == "OK") {
      Address address = Address(
        formattedAddress: "",
        placeName: resp["result"]["name"],
        placeId: placeId,
        latitude: resp["result"]["geometry"]["location"]["lat"],
        longitude: resp["result"]["geometry"]["location"]["lng"],
      );

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("THIS IS DROP OFF POINT");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}
