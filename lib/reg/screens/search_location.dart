
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/select_company.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  PickResult? selectedPlace;
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
    return SafeArea(
      child: Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
             backgroundColor: kWhiteColor,
             title: TextWidget(
               name: kGetAddress2.toUpperCase(),
               textColor: kTextColor,
               textSize: kFontSize,
               textWeight: FontWeight.w600,
             ),
           ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                NewBtn(title: kGetAddress,bgColor:kDoneColor,nextFunction: (){ _searchAddress();
                },),

                selectedPlace == null ? Container() : Text(selectedPlace!.formattedAddress ?? ""),
              ],
            ),
          )),
    );
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


              try{
                List<Location> locations = await locationFromAddress(selectedPlace!.formattedAddress.toString());
                Location placeMark = locations[0];

                List<Placemark> addresses = await placemarkFromCoordinates(placeMark.latitude, placeMark.longitude);
                //List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);

                var first = addresses.first;


                // this is all you need

                String name = first.toString();
                String? subLocality = first.subLocality;
                String? locality = first.locality;//Owerri
                String? administrativeArea = first.administrativeArea;//Imo
                String? postalCode= first.postalCode;
                String? country = first.country;//country
                String? hdh= first.subThoroughfare;//no
                String? ns = first.thoroughfare;//egbu Road
                final coordinates = new Coordinates(placeMark.latitude, placeMark.longitude);

                Coordinates position = coordinates;

                String address = "$name $subLocality $ns $hdh $locality $administrativeArea state, $country";


                setState(() {
                  //Variables.myPosition = position;

                  Variables.searchLocation = selectedPlace!.formattedAddress;
                  Variables.buyerAddress = address;
                  Variables.locality = locality;
                  Variables.administrative = administrativeArea;
                  Variables.country = country;

                  Variables.customerLat = position.latitude;
                  VariablesOne.subLocality = subLocality;
                  AdminConstants.businessSubLocation = ns;

                  // update _address
                });



                Navigator.of(context).pushReplacement
                  (MaterialPageRoute(
                    builder: (context) => SelectCompany()));

                //print("${first.featureName} : ${first.coordinates}");

              }
              catch(e) {

                print("Error occured: $e");
              }




            },
/*forceSearchOnZoomChanged: true,
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
