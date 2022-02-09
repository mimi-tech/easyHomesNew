import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/page_drawer.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BizMap extends StatefulWidget {
  BizMap({required this.index});

  final int index;
  @override
  _BizMapState createState() => _BizMapState();
}

class _BizMapState extends State<BizMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  var geoLocator = Geolocator();
  String address = '';
  late  GoogleMapController _controller;
  List<Marker> allMarkers = [];

  List<dynamic> transitCount = <dynamic>[];
  CameraPosition initalLocation = CameraPosition(
    target:
    LatLng(PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log']),
    zoom: 14.4746,
  );

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<void> getCurrentLocation() async {


    allMarkers.add(Marker(
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log'])));

    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng( PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log']),
              tilt: 0,
              zoom: 18.00)));
    }


    //List<Placemark> newPlace = await Geolocator().placemarkFromCoordinates(PageConstants.getVendor[0]['lat'], PageConstants.getVendor[0]['log']);

    // this is all you need
   /* Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;//Owerri
    String? administrativeArea = placeMark.administrativeArea;//Imo
  String? postalCode= placeMark.postalCode;
    String? country = placeMark.country;//country

    String? ns = placeMark.thoroughfare;

    setState(() {

      address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";

    });*/

  }
  late bool isDrawerBeingShown;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scaffoldKey.currentState!.openEndDrawer();
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

        drawer: PageDrawer(),
        key: _scaffoldKey,
        body: Container(

          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: initalLocation,
                    markers: Set.from(allMarkers),
                    onMapCreated: mapCreated,
                  )),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: SvgPicture.asset('assets/imagesFolder/back_circle.svg',)),
              ),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 20,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kCardRadius),
                      topRight: Radius.circular(kCardRadius),
                      bottomLeft: Radius.circular(kCardRadius),
                      bottomRight: Radius.circular(kCardRadius),
                    ),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            space(),
                            Row(
                              children: <Widget>[
                                Icon(Icons.arrow_upward,color: kDoneColor,),
                                TextWidget(
                                  name: 'Gas station Location'.toUpperCase(),
                                  textColor: kDoneColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),



                              ],
                            ),
                            TextWidget(
                              name: address,
                              textColor: kTextColor,
                              textSize: kFontSize14,
                              textWeight: FontWeight.w500,
                            ),
                            Divider(color: kDoneColor,thickness: 1.5,),

                            TextWidget(
                              name:  PageConstants.vendorCount[widget.index]['cc'],
                              textColor: kLightBrown,
                              textSize: kFontSize,
                              textWeight: FontWeight.w500,
                            ),

                            TextWidget(
                              name:  PageConstants.vendorCount[widget.index]['biz'],
                              textColor: kLightBrown,
                              textSize: kFontSize,
                              textWeight: FontWeight.w500,
                            ),
                            space(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )


            ],
          ),
        )));
  }


}
