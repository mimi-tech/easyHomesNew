// @dart = 2.9


import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/partners/register_business.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/select_company.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/vendorReg/screens/store_address.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:geocoding/geocoding.dart';

class VendorLocationService extends StatefulWidget {
  @override
  _VendorLocationServiceState createState() => _VendorLocationServiceState();
}

class _VendorLocationServiceState extends State<VendorLocationService> {
  PickResult selectedPlace;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            NewBtn(title: kGetAddress,bgColor:kDoneColor,nextFunction: (){ _searchAddress();
          },),
              selectedPlace == null ? Container() : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }

  void getLocation() {}

  void _searchAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: Variables.myKey,
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            //usePlaceDetailSearch: true,
            onPlacePicked: (result) async {

              selectedPlace = result;
              var d = result.addressComponents.first;

              print(d.toJson());


              try{
                var addresses = await Geocoder.local.findAddressesFromQuery(selectedPlace.formattedAddress);
                //final coordinates = new Coordinates(placeMark.latitude, placeMark.longitude);
                //var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                var first = addresses.first;
                // this is all you need

                String name = first.toString();
                String subLocality = first.subLocality;
                String locality = first.locality;//Owerri
                String administrativeArea = first.adminArea;//Imo
                String postalCode= first.postalCode;
                String country = first.countryName;//country
                String hdh= first.subThoroughfare;//no
                String ns = first.thoroughfare;//egbu Road
                Coordinates position = first.coordinates;
                Variables.latPosition = position;
                //String address = "$subLocality $ns $hdh $locality $administrativeArea state, $country";
                String address = selectedPlace.formattedAddress;




                setState(() {
               /*   AdminConstants.businessPosition = position;
                  VendorConstants.companyAddress= address;
                  VendorConstants.vendorSearchLocation = selectedPlace.formattedAddress;
                  AdminConstants.businessSubLocation = ns;
                  Variables.locality = locality;
                  Variables.administrative = administrativeArea;
                  Variables.country = country;*/


                  //Variables.myPosition.latitude = position.latitude;
                  Variables.buyerAddress = address;

                  Variables.locality = locality;
                  Variables.administrative = administrativeArea;
                  Variables.country = country;
                  VendorConstants.vendorSearchLocation = selectedPlace.formattedAddress;
                  AdminConstants.businessSubLocation = ns;

                  AdminConstants.lat = position.latitude;
                  AdminConstants.log = position.longitude;

                  //update _address
                });


                //Navigator.pop(context);
                Navigator.of(context).pushReplacement
                  (MaterialPageRoute(
                    builder: (context) => OutletAddress()));
                //print("${first.featureName} : ${first.coordinates}");

              }
              catch(e) {

                print("Error occurred: $e");
              }




            },
                           /* forceSearchOnZoomChanged: true,
                          automaticallyImplyAppBarLeading: false,
                          autocompleteLanguage: "en",
                          region: 'ng',
                          selectInitialPosition: true,
                           selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                             print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                             return isSearchBarFocused
                                 ? Container()
                                 : FloatingCard(
                                     bottomPosition: 0.0,    // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                     leftPosition: 0.0,
                                     rightPosition: 0.0,
                                     width: 500,
                                     borderRadius: BorderRadius.circular(12.0),
                                     child: state == SearchingState.Searching
                                         ? Center(child: CircularProgressIndicator())
                                         : RaisedButton(
                                             child: Text("Pick Here"),
                                             onPressed: () async {

                                             },
                                           ),
                                   );
                           },
                           pinBuilder: (context, state) {
                             if (state == PinState.Idle) {
                               return Icon(Icons.favorite_border);
                             } else {
                               return Icon(Icons.favorite);
                             }
                           },*/

          );
        },
      ),
    );
  }
}


