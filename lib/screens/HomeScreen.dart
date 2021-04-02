import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ar_navigator/DataHandler/appData.dart';
import 'package:ar_navigator/assistants/assistantMethods.dart';
import 'package:ar_navigator/screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'PlacesScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String _darkMapStyle;
  GoogleMapController newGoogleMapController;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Position currentPosition;
  var geoLocator = Geolocator();

  Set<Marker> markersSet = {};
  Future _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style/dark.json');
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is ur address: " + address);
  }

  Future _setMapStyle() async {
    final controller = await _controllerGoogleMap.future;
    controller.setMapStyle(_darkMapStyle);
  }

  static final CameraPosition _kKPI = CameraPosition(
    target: LatLng(50.4490469, 30.4568193),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyle();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 200),
            child: AppBar(
              automaticallyImplyLeading:
                  false, // this will hide Drawer hamburger icon
              actions: <Widget>[Container()],
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                              if (res == "ObtainDirection") {
                                await getPlaceDirection();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 40, 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(children: [
                                Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Colors.grey[200],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Куди прямуємо?",
                                  style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                            )),
                      ])),
            )),
        //map
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/userpic.png",
                    ),
                    radius: 50,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Костянтин Сторожук",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: Colors.yellow,
                ),
                title: Text(
                  "Профіль",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              ListTile(
                onTap:()=> Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlacesScreen())),
                leading: Icon(
                  Icons.map_outlined,
                  color: Colors.yellow,
                ),
                title: Text(
                  "Ваші місця",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  "Вийти?",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
              Divider(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.yellow,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
                initialCameraPosition: _kKPI,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                polylines: polylineSet,
                markers: markersSet,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;
                  _setMapStyle();
                  locatePosition();
                })
          ],
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false).startLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).endLocation;

    var startLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var endLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        startLatLng, endLatLng);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    pLineCoordinates.clear();
    if (decodePolylinePointsResult.isNotEmpty) {
      decodePolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.yellowAccent,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (startLatLng.latitude > endLatLng.latitude &&
        startLatLng.longitude > endLatLng.longitude) {
      latLngBounds = LatLngBounds(southwest: endLatLng, northeast: startLatLng);
    } else if (startLatLng.latitude > endLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(endLatLng.latitude, startLatLng.longitude),
          northeast: LatLng(startLatLng.latitude, endLatLng.longitude));
    } else if (startLatLng.longitude > endLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(startLatLng.latitude, endLatLng.longitude),
          northeast: LatLng(endLatLng.latitude, startLatLng.longitude));
    } else {
      latLngBounds = LatLngBounds(southwest: startLatLng, northeast: endLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker startLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: initialPos.placeName, snippet: "Я тут"),
        position: startLatLng,
        markerId: MarkerId("startId"));
    Marker endLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Треба сюди"),
        position: endLatLng,
        markerId: MarkerId("endId"));

    setState(() {
      markersSet.add(startLocMarker);
      markersSet.add(endLocMarker);
    });
  }
}
