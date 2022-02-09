import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/customer_txn.dart';
import 'package:easy_homes/payment/methods.dart';

import 'package:easy_homes/reg/constants/btn.dart';

import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/reg/screens/not_close.dart';
import 'package:easy_homes/reg/screens/search_location.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/back_icon.dart';
import 'package:easy_homes/utility/matrix.dart';
import 'package:flinq/flinq.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

class SelectCompany extends StatefulWidget {
  @override
  _SelectCompanyState createState() => _SelectCompanyState();
}

class _SelectCompanyState extends State<SelectCompany> {
   GoogleMapController? _controller;
  List<Marker> allMarkers = [];
  var itemsData = <dynamic>[];
  Color radioColor1 = kBlackColor;
  Color radioColor2 = kRadioColor;
  late int selectedRadio;
  bool date = false;
  bool searchLocation = true;
  TextEditingController _address = TextEditingController();
  TextEditingController _phone = TextEditingController();
  late CameraPosition initialSearchLocation;
  bool isSwitched = false;


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

   Stream<dynamic>? query;
   StreamSubscription? subscription;


  bool readPhoneNo = true;
  bool phoneAutoFocus = false;
  bool readAddress = true;



  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation();
    selectedRadio = 1;
    _phone.text = Variables.userPH!;
    //_address.text = Variables.searchLocation;
    _address.text = Variables.buyerAddress!;
    Future.delayed(const Duration(seconds: 4), (){setState(() {

    });});
  }
  /// Markers loading flag
  bool _areMarkersLoading = true;

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    /*Variables.searchLocation = null;
    Variables.buyerAddress = null;*/
    if(subscription != null) {
      subscription!.cancel();
    }
  }


  getLocation() async {


   setState(()  {
     //final BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);
     allMarkers.add(Marker(
         zIndex: 2,
         flat: true,
         anchor: Offset(0.5, 0.5),
         markerId: MarkerId('myMarker'),
         draggable: false,
         infoWindow: InfoWindow(
           title: "Delivery Point",
           snippet: "current location",
         ),
         icon: BitmapDescriptor.defaultMarker,
         position: LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude)));
   });



    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 30,
              target: LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude),
              tilt: 0,
              zoom: 16.00)));
    }
  }

  CameraPosition initalLocation = CameraPosition(
    target: LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude),
    zoom: 14.4746,
  );

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  bool _publishModal = false;
  static List<dynamic> matchedBusiness = <dynamic>[];
  var id = <dynamic>[];
  var idSecond = <dynamic>[];
  bool warning = false;
  bool block = false;
  bool progress = false;
  var distance = 0;
  //final Distance distanceLat = new Distance();
  // ignore: close_sinks
  var radius = BehaviorSubject<int>.seeded(Variables.radius!);
  var p1 = Variables.grandTotal * 20 / 100.round();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

          // drawer: GasCompanyList(),
            body: ModalProgressHUD(
              inAsyncCall: progress,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        Container(
                            height: MediaQuery
                                .of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: initalLocation,
                              markers: Set.from(allMarkers),
                              onMapCreated: mapCreated,
                              //myLocationEnabled: true,

                            )),
                        /*getting the drawer*/
                           GestureDetector(
                             onTap: (){
                               Navigator.pop(context);
                             },
                             child: Container(
                                 margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 10),
                                 child: BackIcon()),
                           ),
                        /*getting the container for self or others */
                      ],
                    ),
                    Container(
                      //height:MediaQuery.of(context).size.height/2,

                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(kmodalborderRadius),
                            topLeft: Radius.circular(kmodalborderRadius),
                          )),

                      child: Column(
                        children: <Widget>[
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    activeColor: kBlackColor,
                                    onChanged: (dynamic val) {
                                      setSelectedRadio(val);

                                      setState(() {
                                        radioColor1 = kBlackColor;

                                        radioColor2 = kRadioColor;

                                        date = false;
                                      });
                                    },
                                  ),
                                  TextWidget(
                                    name: kWhoToDeliver,
                                    textColor: radioColor1,
                                    textSize: 14,
                                    textWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    activeColor: kBlackColor,
                                    onChanged: (dynamic val) {
                                      setSelectedRadio(val);

                                      setState(() {
                                        radioColor2 = kBlackColor;

                                        radioColor1 = kRadioColor;

                                        date = true;
                                      });
                                    },
                                  ),
                                  TextWidget(
                                    name: kWhoToDeliver2,
                                    textColor: radioColor2,
                                    textSize: 14,
                                    textWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 1.0,
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            color: kDividerColor,
                          ),


                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchLocation()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: kHorizontal),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: (kCurrentLocation),
                                    style: GoogleFonts.oxanium(
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(
                                          kFontSize, ),
                                      color: kProfile,
                                    ),

                                    children: <TextSpan>[
                                      TextSpan(
                                        text: kCurrentLocation2,
                                        style: GoogleFonts.oxanium(
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenUtil().setSp(
                                              kFontSize, ),
                                          color: kLightBrown,
                                        ),
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ),

/*showing the textfield*/

                          Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: kHorizontal),
                            child: Column(
                              children: <Widget>[
                                Platform.isIOS
                                    ? CupertinoTextField(

                                  controller: _address,
                                  maxLines: null,
                                  readOnly: true,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  keyboardType: TextInputType.text,
                                  style: Fonts.textSize,
                                  placeholder: kRecipientAdd,
                                  placeholderStyle: GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(
                                        kFontSize, ),
                                    color: kHintColor,
                                  ),

                                  onChanged: (String value) {
                                    Variables.address = value;
                                  },

                                ) :
                                TextField(
                                  controller: _address,
                                  maxLines: null,
                                  readOnly: true,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  keyboardType: TextInputType.text,
                                  style: Fonts.textSize,
                                  decoration: Variables.addressDecoration,

                                  onChanged: (String value) {
                                    Variables.address = value;
                                  },
                                )
                                ,
                                SizedBox(
                                  height: 15.h,
                                ),
                                Platform.isIOS ? CupertinoTextField(
                                  controller: _phone,
                                  readOnly: readPhoneNo,
                                  autofocus: phoneAutoFocus,
                                  //initialValue: '+2347068360382',
                                  maxLines: null,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  keyboardType: TextInputType.text,
                                  style: Fonts.textSize,

                                  suffix: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          readPhoneNo = false;
                                          phoneAutoFocus = true;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/imagesFolder/Change.svg',
                                      )),

                                  placeholder: kRecipientAdd,
                                  placeholderStyle: GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(
                                        kFontSize,
                                        ),
                                    color: kHintColor,
                                  ),

                                  onChanged: (String value) {
                                    Variables.buyerMobileNumber = value;
                                  },
                                ) :
                                TextField(
                                  controller: _phone,

                                  //initialValue: '+2347068360382',
                                  maxLines: null,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  keyboardType: TextInputType.number,
                                  style: Fonts.textSize,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              readPhoneNo = false;
                                              phoneAutoFocus = true;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/imagesFolder/Change.svg',
                                          )),
                                      errorStyle: GoogleFonts.oxanium(
                                        fontSize: ScreenUtil().setSp(
                                            kFontSize,
                                            ),
                                        color: kRedColor,
                                      ),
                                      hintText: kRecipientAdd,
                                      hintStyle: GoogleFonts.oxanium(
                                        fontSize: ScreenUtil().setSp(
                                            kFontSize,
                                            ),
                                        color: kHintColor,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kDividerColor,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kDividerColor))),

                                  onChanged: (String value) {
                                    Variables.buyerMobileNumber = value;
                                  },
                                )

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          _publishModal == true
                              ? PlatformCircularProgressIndicator()
                              : Btn(
                              bgColor: kLightBrown,
                              nextFunction: () {
                                moveToNext();
                              }),
                          SizedBox(
                            height: 20.h,
                          ),


                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  Future<void> moveToNext() async {

    if (_phone.text.length < 10) {
      Fluttertoast.showToast(
          msg: 'Sorry give us your phone number',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {

      /*show a bottomSheet where user where enter there transaction pin*/


      Variables.buyerMobileNumber = _phone.text.trim();


      //check if user has method of payment
      if ( Variables.mop == null) {
        VariablesOne.checkPayment = true;
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethods()));


      } else {
        getBusiness();
      }
    }

    }


  void getCloseVendors(){
    print("alright me");
    setState(() {
      progress = true;
      warning = false;
      block = false;
      Variables.markers.clear();
    });
    //check the vendor within the customer locality in the company selected
    try {
      // ignore: close_sinks
      var radius = BehaviorSubject<int>.seeded(Variables.radius!);

      var ref = FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('appr', isEqualTo: true)
          .where('tr', isEqualTo: false)
          .where('ol', isEqualTo: true);
      GeoFirePoint center = geo.point(
          latitude: Variables.myPosition.latitude,
          longitude: Variables.myPosition.longitude);
      print('bbbbbbbbbbb');
      // subscribe to query
      subscription = radius.switchMap((rad) {
        return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad.toDouble(),
            field: 'vPos',
            strictMode: true
        );
      }).listen(_updateMarkers);
    } catch (e) {
      setState(() {
        progress = false;
      });
      print(e);
    }
  }


  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print('dddddddd');
    Variables.markers.clear();
    if (documentList.length == 0) {
      setState(() {
        progress = false;
        //for the markers

      });
      subscription!.cancel();
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorCustomerMatch()));

      print('empty');

      // NotClose();
    } else {
      for (DocumentSnapshot document in documentList) {
        Variables.markers.add(document);
      }

      subscription!.cancel();
      setState(() {
        progress = false;
      });


      print('dddddddd${Variables.markers}');
      //Navigator.pop(context);

      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorCustomerMatch()));


    }
  }


  Future<void> getBusiness() async {
    setState(() {
      progress = true;
    });
    // ignore: close_sinks
    rentIsFalse();

  }



  Future<void> _updateMarkerCash(List<DocumentSnapshot> documentList) async {
    try{
      if (documentList.length == 0)  {
        subscription!.cancel();
        setState(() {
          progress = false;
        });

        notClose();

      } else {
        subscription!.cancel();
      documentList.forEach((DocumentSnapshot document) async {
        matchedBusiness.add(document['id']);
      });


//get the business details
        final QuerySnapshot result = await  FirebaseFirestore.instance
            .collection('AllBusiness')
            .where('id', isEqualTo: matchedBusiness[0])
            .get();
        final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
          print('empty doc');
        } else {
          print('not empty');
          print('yyyyyy${matchedBusiness[0]}');
          for (DocumentSnapshot document in documents) {
            Variables.matchedBusiness = document;

            print('lellll${Variables.matchedBusiness}');
            getDeliveryFee();

          }

        }}

    }catch(e){
      print('0000000$e');
    }

  }

  Future<void> getDeliveryFee() async {

    //update customer delivery fee
    /*get the time and distance it will take to cover the distance*/


    //setting the actual gas prize for the gas station matched
    Variables.gasEstimatePrice = Variables.totalGasKG * Variables.matchedBusiness['gas'];
    Variables.grandTotal =  Variables.gasEstimatePrice;


    try{

      VariablesOne.deliveryFee =Variables.cloud!['df']['fdf'];
      getCloseVendors();
//       String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.myPosition.latitude},${Variables.myPosition.longitude}&destinations=${Variables.matchedBusiness['lat']},${Variables.matchedBusiness['log']}&departure_time=now&key=${Variables.myKey}";
//
//       http.Response res = await http.get(Uri.parse(url));
//       if(res.statusCode == 200) {
//
//         Map<String, dynamic> mapItems = json.decode(res.body);
//         print("jjjjjj");
//
//         print(mapItems);
//         print(res.body);
//         var videos = mapItems['rows']; //returns a List of Maps
//         for (var item in videos) {
//
//           //iterate over the list
//           Map myMap = item; //store each map
//           final items = (myMap['elements'] as List).map((i) => Matrix.fromJson(i));
//           for (final item in items) {
//             dynamic d = item.distance['value'];
//
//             var e = d *Variables.cloud!['df']['dist'];
//             distance = e.round() * 2;
//
//             if(d >Variables.cloud!['df']['fdist']){
//               VariablesOne.deliveryFee = distance;
//             }else{
//               VariablesOne.deliveryFee =Variables.cloud!['df']['fdf'];
//
//
//             }
//
//            /* if(Variables.buyCylinder == true){
//               var e = d *Variables.cloud!['df'];
//               distance = e.round();
//             }else {
//               var e = d *Variables.cloud!['df'];
//               print('yyy$e');
//               distance = e.round() * 2;
//               VariablesOne.deliveryFee = distance;
//
//               print('666666666 ${VariablesOne.deliveryFee}');
//             }*/
//
//           }
//           print("okkkkkk");
//           //get close businesses
//           getCloseVendors();
//
//
//         }
//
//
//       }else{
//         VariablesOne.deliveryFee =Variables.cloud!['df']['fdf'];
//         //get close businesses
//         getCloseVendors();
//
//         //calculate the distance manually
//         /*final dynamic meter = distanceLat.as(LengthUnit.Kilometer,
//             new LatLng(Variables.myPosition.latitude,Variables.myPosition.longitude),
//             new LatLng(Variables.matchedBusiness['lat'],Variables.matchedBusiness['log'])
//         );
//
//         print('jjjj $meter');
//
//         if(Variables.buyCylinder == true){
//           var e = meter *Variables.cloud!['df'];
//           distance = e.round();
//           print('666666666 $distance');
//         }else {
//           var e = meter *Variables.cloud!['df'];
//           print('yyy$e');
//           distance = e.round() * 2;
//           VariablesOne.deliveryFee = distance;
//
//           print('666666666 ${VariablesOne.deliveryFee}');
//         }
// */




    }catch (e){
      progress = false;
      VariablesOne.deliveryFee =Variables.cloud!['df']['fdf'];
      print('eeeeeeeeeee $e');
      getCloseVendors();


    }

  }

  void notClose() {
    /* Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => NotClose(),
      ),
          (route) => false,
    );*/
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: NotClose()));
  }

  Future<void> rentIsFalse() async {

      try{
        //getting business that is close

        var ref = FirebaseFirestore.instance
            .collection('AllBusiness')
            .where('apr', isEqualTo: true)
            .where('ol', isEqualTo: true);
        GeoFirePoint center = geo.point(latitude: Variables.myPosition.latitude, longitude: Variables.myPosition.longitude);

        // subscribe to query
        subscription = radius.switchMap((rad) {
          return geo.collection(collectionRef: ref).within(
              center: center,
              radius: rad.toDouble(),
              field: 'pos',
              strictMode: true);

        }).listen(_updateMarkerCash);
      }catch(e){
        print('ppppp${e.toString()}');
      }}








}



