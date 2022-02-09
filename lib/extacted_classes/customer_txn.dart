import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/not_close.dart';
import 'package:easy_homes/utility/matrix.dart';
import 'package:flinq/flinq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/payment/methods.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/block_text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class CustomerTxnPin extends StatefulWidget {
  @override
  _CustomerTxnPinState createState() => _CustomerTxnPinState();
}

class _CustomerTxnPinState extends State<CustomerTxnPin> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final _random = new Random();
  static List<dynamic> matchedBusiness = <dynamic>[];
  var id = <dynamic>[];
  var idSecond = <dynamic>[];
  bool warning = false;
  bool block = false;
  bool progress = false;
  var itemsData = <dynamic>[];
  Geoflutterfire geo = Geoflutterfire();
  var distance = 0;
   //final Distance distanceLat = new Distance();

  late Stream<dynamic> query;
  late StreamSubscription subscription;
  var radius = BehaviorSubject<int>.seeded(Variables.radius!);
  var p1 = Variables.grandTotal * 20 / 100.round();

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

   // subscription.cancel();
  }

  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );
    return PinPut(

      autofocus: true,
      validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Variables.mobilePin = pine;
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kTextFieldBorderColor,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Column(
    children: <Widget>[
      spacer(),

      GestureDetector(
        onTap: (){Navigator.pop(context);},
        child: Container(
          alignment: Alignment.topRight,
         margin: EdgeInsets.symmetric(horizontal: 10),
         child: Icon(Icons.cancel,color: kRedColor,size: 30,)
        ),
      ),
      spacer(),

      TextWidgetAlign(
        name: 'Hello ${Variables.userFN! } ${Variables.userLN }'.toUpperCase(),
        textColor: kLightBrown,
        textSize: 22,
        textWeight: FontWeight.bold,
      ),


      spacer(),

      Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: TextWidgetAlign(
          name: kTxnText,
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.w500,
        ),
      ),
      spacer(),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: animatingBorders(),
      ),

      GestureDetector(
        onTap: () {
          _pinPutController.text = '';


        },
        child: Text(kEditMobileClear,
          style: GoogleFonts.oxanium(
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(
                kFontSize, ),
            color: kLightBrown,
          ),
        ),
      ),
      spacer(),
      warning == true?
      WarningText():Text(''),

      block == true ?
      BlockText():Text(''),

     progress == true?Center(child: PlatformCircularProgressIndicator()): BtnSecond(title: 'Next', nextFunction: () {

       moveToNext();
      }, bgColor: kDoneColor,),



      spacer(),



    ]
    )
    )
    );
  }

  void moveToNext() {
    //decript pin

    final decrypted = Encryption.decryptAES(Variables.currentUser[0]['tx']);


    if ((_pinPutController.text.length == null) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else if (decrypted != _pinPutController.text) {
      Variables.counter++;
      if (Variables.counter == 3) {
        setState(() {
          warning = true;
        });
      }


      Fluttertoast.showToast(
          msg: 'Sorry incorrect pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);


      if (Variables.counter >= 4) {
//        block account

        try {
          FirebaseFirestore.instance.collection('userReg')
              .doc(Variables.currentUser[0]['ud'])
              .set({
            'bl': true,
          },SetOptions(merge: true));
          setState(() {
            warning = false;
            block = true;
          });

          Future.delayed(const Duration(seconds: 7), () {
            Navigator.pushReplacement(context, PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: SupportScreen()));
          });
        } catch (e) {
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      }
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }



      //check if user has method of payment
      if ( Variables.mop == null) {
        Navigator.pop(context);
        VariablesOne.checkPayment = true;
         Navigator.push(
    context, PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: PaymentMethods()));



      } else {
        getBusiness();
      getCloseVendors();
      }
    }
  }


  void getCloseVendors(){
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
      subscription.cancel();
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorCustomerMatch()));

      print('empty');

     // NotClose();
    } else {
      for (DocumentSnapshot document in documentList) {
        Variables.markers.add(document);
      }

      subscription.cancel();
      setState(() {
        progress = false;
      });


print('dddddddd${Variables.markers}');
      Navigator.pop(context);

      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorCustomerMatch()));


    }
    }


  Future<void> getBusiness() async {
    setState(() {
      progress = true;
    });
    // ignore: close_sinks

    if(Variables.currentUser[0]['mp'] == kCash){



      print('9999999 ${p1.round()}');
      //check if user is renting cylinder
      if(Variables.checkRent == false) {
         rentIsFalse();

     }else{
        print('rent is true cash');
        rentIsTrue();
      }


    }else{
      print('909090');
      //when payment method is not cash

      if(Variables.checkRent == false) {
        notCash();
      }else{
        print('rent is true wallet');

        notCashRentIsTrue();
      }

    }
  }

  Future<void> _updateBizMarkers(List<DocumentSnapshot> documentList) async {
    //subscription.cancel();
    if (documentList.length == 0) {
      setState(() {
        progress = false;
      });
      notClose();

    } else {
      for (DocumentSnapshot document in documentList) {

        matchedBusiness.add(document['id']);
        print('vvvvvv$matchedBusiness');
      }

    //get the business details
    final QuerySnapshot result = await  FirebaseFirestore.instance
        .collection('AllBusiness')
        .where('id', isEqualTo: matchedBusiness[0])
        .get();
    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {

      for (DocumentSnapshot document in documents) {
        Variables.matchedBusiness = document;
        print('xxxxxxx${ Variables.matchedBusiness}');
        getDeliveryFee();

      }

    }}

  }


  Future<void> _updateMarkerCash(List<DocumentSnapshot> documentList) async {
   try{
     print('9292929');
     documentList.forEach((DocumentSnapshot document) async {
       Map<String, dynamic> data = document.data() as Map<String, dynamic>;
       idSecond.add(data['id']);
     });

/*check if both list is not empty*/
     if ((id.length == 0) || (idSecond.length == 0)) {
       subscription.cancel();
       setState(() {
         progress = false;
         //controller.dispose();
       });
       print('moving oooooo');

       notClose();
       //getCustomerWaitingCash();

     } else {
       print('202020');
       final intersectedCollection = id.intersection(idSecond); // [5]
       matchedBusiness = intersectedCollection;




//get the business details
     final QuerySnapshot result = await  FirebaseFirestore.instance
         .collection('AllBusiness')
         .where('id', isEqualTo: matchedBusiness[0])
         .get();
     final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
     } else {
      for (DocumentSnapshot document in documents) {
         Variables.matchedBusiness = document;

         getDeliveryFee();

       }

     }

     }

   }catch(e){
    print('0000000$e');
   }

  }

  Future<void> getDeliveryFee() async {
    print('lllll${Variables.matchedBusiness}');
    print('lllll${Variables.matchedBusiness['lat']}');
    //update customer delivery fee
    /*get the time and distance it will take to cover the distance*/
    print('wwww ${Variables.matchedBusiness['lat']}');
    print('wwww ${Variables.matchedBusiness['log']}');
    try{
      String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.myPosition.latitude},${Variables.myPosition.longitude}&destinations=${Variables.matchedBusiness['lat']},${Variables.matchedBusiness['log']}&departure_time=now&key=${Variables.myKey}";

      http.Response res = await http.get(Uri.parse(url));
      if(res.statusCode == 200) {
        Map<String, dynamic> mapItems = json.decode(res.body);
         print(mapItems);
        var videos = mapItems['rows']; //returns a List of Maps
        for (var item in videos) {
          //iterate over the list
          Map myMap = item; //store each map
          final items = (myMap['elements'] as List).map((i) => Matrix.fromJson(i));
          for (final item in items) {
            int d = item.traffic['value'];
            if(Variables.buyCylinder == true){
              var e = d *Variables.cloud!['df'];
              distance = e.round();
              Variables.timeTaken = item.traffic['text'];
              Variables.timeTakenValues = item.traffic['value'];
              Variables.distance = item.distance['text'];


            }else {
              var e = d *Variables.cloud!['df'];
              distance = e.round() * 2;
              VariablesOne.deliveryFee = distance;
              Variables.timeTaken = item.traffic['text'];
              Variables.timeTakenValues = item.traffic['value'];
              Variables.distance = item.distance['text'];

            }

          }
        }


      }else{
        //calculate the distance manually
        final dynamic meter = Geolocator.distanceBetween(Variables.myPosition.latitude, Variables.myPosition.longitude,
            Variables.matchedBusiness['lat'], Variables.matchedBusiness['log']);

        // final dynamic meter = distanceLat.as(LengthUnit.Kilometer,
        //     new LatLng(Variables.myPosition.latitude,Variables.myPosition.longitude),
        //     new LatLng(Variables.matchedBusiness['lat'],Variables.matchedBusiness['log'])
        //);

        print('jjjj $meter');

        if(Variables.buyCylinder == true){
          var e = meter *Variables.cloud!['df'];
          distance = e.round();
          print('666666666 $distance');
        }else {
          var e = meter *Variables.cloud!['df'];
          print('yyy$e');
          distance = e.round() * 2;
          VariablesOne.deliveryFee = distance;

          print('666666666 ${VariablesOne.deliveryFee}');
        }


      }


    }catch (e){
      progress = false;
      VariablesOne.deliveryFee = 200;
      print('eeeeeeeeeee $e');
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
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("AllBusiness")
        .where('wal', isGreaterThanOrEqualTo: p1.round())
        .where('ol', isEqualTo: true)
        .where('apr', isEqualTo: true)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      subscription.cancel();

      print('this is num one empty');
      setState(() {
        progress = false;
      });
      print('uyuyu');
      notClose();

    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;


        print('this is num one not empty');
        id.add(data['id']);
      }
      print('iddddd $id');

    print('id1d2ddd $id');

    try{
      //getting business that is close

      var ref = FirebaseFirestore.instance
          .collection('AllBusiness')
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

  void notCash() {
    try{
      var ref = FirebaseFirestore.instance
          .collection('AllBusiness')
          .where('ol', isEqualTo: true)
          .where('apr',isEqualTo: true);

      GeoFirePoint center = geo.point(latitude: Variables.myPosition.latitude, longitude: Variables.myPosition.longitude);

      // subscribe to query
      subscription = radius.switchMap((rad) {
        return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad.toDouble(),
            field: 'pos',
            strictMode: true);
      }).listen(_updateBizMarkers);
    }catch (e){
      print('55555555 $e');
    }
  }

  Future<void> rentIsTrue() async {
    print('p1p1p1p$p1');
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("AllBusiness")
        .where('wal', isGreaterThanOrEqualTo: p1.round())
        .where('ol', isEqualTo: true)
        .where('apr', isEqualTo: true)
        .where('re',isEqualTo: true)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      subscription.cancel();

      print('this is num one empty');
      setState(() {
        progress = false;
      });
      print('moving aaaaaaaa');
      notClose();

    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print('this is num one not empty');
        id.add(data['id']);
      }
      print('iddddd $id');

    print('id1d2ddd $id');

    try{
      //getting business that is close

      var ref = FirebaseFirestore.instance
          .collection('AllBusiness')
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

  void notCashRentIsTrue() {
    try{
      var ref = FirebaseFirestore.instance
          .collection('AllBusiness')
          .where('ol', isEqualTo: true)
          .where('apr',isEqualTo: true)
          .where('re',isEqualTo: true);

      GeoFirePoint center = geo.point(latitude: Variables.myPosition.latitude, longitude: Variables.myPosition.longitude);

      // subscribe to query
      subscription = radius.switchMap((rad) {
        return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad.toDouble(),
            field: 'pos',
            strictMode: true);
      }).listen(_updateBizMarkers);
    }catch (e){
      print('55555555 $e');
    }
  }






}

