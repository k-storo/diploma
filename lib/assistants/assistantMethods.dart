import 'package:ar_navigator/DataHandler/appData.dart';
import 'package:ar_navigator/assistants/requestAssistant.dart';
import 'package:ar_navigator/configMaps.dart';
import 'package:ar_navigator/models/address.dart';
import 'package:ar_navigator/models/allUsers.dart';
import 'package:ar_navigator/models/directionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAdress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey&language=uk";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      placeAdress = response["results"][0]["formatted_address"];

      Address userStartAddress = new Address();
      userStartAddress.latitude = position.latitude;
      userStartAddress.longitude = position.longitude;
      userStartAddress.placeName = placeAdress;

      Provider.of<AppData>(context, listen: false)
          .updateStartLocationAddress(userStartAddress);
    }

    return placeAdress;
  }

  static Future<String> searchMyHomeAddress(userCurrentInfo, context) async {
    String homeAddress = "";

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${userCurrentInfo.homeLatitude},${userCurrentInfo.homeLongitude}&key=$mapKey&language=uk";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      homeAddress = response["results"][0]["formatted_address"];

      Address myHomeAddress = new Address();
      myHomeAddress.latitude = userCurrentInfo.homeLatitude;
      myHomeAddress.longitude = userCurrentInfo.homeLongitude;
      myHomeAddress.placeName = homeAddress;
    }

    return homeAddress;
  }

  static Future<String> searchMyWorkAddress(userCurrentInfo, context) async {
    String workAddress = "";

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${userCurrentInfo.workLatitude},${userCurrentInfo.workLongitude}&key=$mapKey&language=uk";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      workAddress = response["results"][0]["formatted_address"];

      Address myWorkAddress = new Address();
      myWorkAddress.latitude = userCurrentInfo.homeLatitude;
      myWorkAddress.longitude = userCurrentInfo.homeLongitude;
      myWorkAddress.placeName = workAddress;
    }

    return workAddress;
  }

  static Future<String> searchMyEducationAddress(
      userCurrentInfo, context) async {
    String educationAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${userCurrentInfo.educationLatitude},${userCurrentInfo.educationLongitude}&key=$mapKey&language=uk";
    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      educationAddress = response["results"][0]["formatted_address"];
      Address myEducationAddress = new Address();
      myEducationAddress.latitude = userCurrentInfo.homeLatitude;
      myEducationAddress.longitude = userCurrentInfo.homeLongitude;
      myEducationAddress.placeName = educationAddress;
    }
    return educationAddress;
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);
    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey&language=uk";
    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
}
