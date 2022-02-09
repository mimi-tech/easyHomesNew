import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/show_prize.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationMap extends StatefulWidget {
  @override
  _StationMapState createState() => _StationMapState();
}

class _StationMapState extends State<StationMap> {

  String address = '';
   GoogleMapController? _controller;
  List<Marker> allMarkers = [];

  List<dynamic> transitCount = <dynamic>[];

   BitmapDescriptor? sourceIcon;

  CameraPosition initalLocation = CameraPosition(
    target:
    LatLng(Constant1.venLat ,  Constant1.venLog),
    zoom: 14.4746,
  );


  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
  bool progress = true;


  Future<void> getCurrentLocation() async {


    allMarkers.add(Marker(
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(Constant1.venLat ,  Constant1.venLog)));

    if (_controller != null) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng( Constant1.venLat , Constant1.venLog),
              tilt: 0,
              zoom: 18.00)));
    }



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     getCurrentLocation();

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height *0.8,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initalLocation,
          markers: Set.from(allMarkers),
          onMapCreated: mapCreated,
        )
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 70,
              width: 70,
              decoration:BoxDecoration(
                shape: BoxShape.circle,
                color:kSeaGreen,
              ),
              child: ShowGasPrize(title:kGasP2,prize:Constant1.stationDocuments![0]['gas'])

            )
        ),
      ],
    );
  }
}
