import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/back_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MatchMap extends StatefulWidget {
  @override
  _MatchMapState createState() => _MatchMapState();
}

class _MatchMapState extends State<MatchMap> {

  //late GoogleMapController _controller;
  List<Marker> allMarkers = [];
  late Stream<dynamic> query;

  var itemsData = <dynamic>[];
  var id = <dynamic>[];
  var realData = <dynamic>[];
  var idSecond = <dynamic>[];

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor destinationIcon;

  void setSourceAndDestinationIcons() async {
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');
  }

  void getMarkers(){
    for(int i= 0; i < Variables.markers.length; i++) {
      initMarker(Variables.markers[i].data(), Variables.markers[i].documentID);

    }
  }


  void initMarker(lugar, lugaresid) {
    var markerIdVal = lugaresid;
    final MarkerId markerId = MarkerId(markerIdVal);
    GeoPoint pos = lugar['vPos']['geopoint'];
// creating a new MARKER
    final Marker marker = Marker(
      icon: destinationIcon,//BitmapDescriptor.defaultMarker,
      flat: true,
      anchor: Offset(0.5, 0.5),
      markerId: markerId,
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: lugar['Lugar'], snippet: lugar['tipo']),

    );
    setState(() {
// adding a new marker to map
      markers[markerId] = marker;
    });
  }
  static final CameraPosition _kGooglePlex = CameraPosition(
      bearing: 30,
      target: LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude),
      tilt: 0,
      zoom: 18.00
  );





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setSourceAndDestinationIcons();
    //getMarkers();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height /2,
        width: MediaQuery.of(context).size.width,
        child:Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[

            BackIcon(),
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              // initialCameraPosition: initalLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
              //onMapCreated: mapCreated,
            ),
          ],
        ));
  }
}
