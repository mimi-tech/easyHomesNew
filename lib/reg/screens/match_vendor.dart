import 'dart:async';
import 'dart:io';

import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/extacted_classes/cancel_booking.dart';
import 'package:easy_homes/extacted_classes/match_construct.dart';
import 'package:easy_homes/extacted_classes/match_map.dart';
import 'package:flinq/flinq.dart';
import 'package:easy_homes/payment/methods.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';

import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/connect.dart';
import 'package:easy_homes/reg/screens/customer_upcoming_screen.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/utility/countOne.dart';

import 'package:easy_homes/utility/matrix.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/utility/ripple_animation.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';

import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/strings/strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';


class VendorCustomerMatch extends StatefulWidget {
  @override
  _VendorCustomerMatchState createState() => _VendorCustomerMatchState();
}

class _VendorCustomerMatchState extends State<VendorCustomerMatch> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool _publishModal = false;
  static Geoflutterfire geo = Geoflutterfire();
late Timer _timer;
  var p1 = VariablesOne.deliveryFee *Variables.cloud!['df']['bky2'] / 100.round();

  double lat = Variables.myPosition.latitude;
  double log = Variables.myPosition.longitude;
  static final now = DateTime.now();
   dynamic distValue;

  /*current date*/
  static var date = new DateTime.now().toString();
  static var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";

  /*check if date of delivery is now or later*/

  bool checkDate = Variables.selectedDate.isBefore(now);
  dynamic sumQty;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<dynamic> query;
  late StreamSubscription subscription;
  var itemsData = <dynamic>[];
  var id = <dynamic>[];
  var realData = <dynamic>[];
  var idSecond = <dynamic>[];
  GeoFirePoint point = geo.point(
      latitude: Variables.myPosition.latitude,
      longitude: Variables.myPosition.longitude);


String payType = '';
  Widget spacerWidth() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.02);
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    PaystackPlugin().initialize(publicKey:Variables.cloud!['pk']);

    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => setState((){}));
cancelTimer();
}

//cancelTimer
  void cancelTimer(){
    Future.delayed(const Duration(seconds: 3), () {
_timer.cancel();
    });
    }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();

  }

  @override
  Widget build(BuildContext context) {
    return _publishModal == true
        ? RipplesAnimation()
        : SafeArea(
            child: PlatformScaffold(
                body: SingleChildScrollView(
                    child: Column(children: <Widget>[
            MatchMap(),
            MatchConstruct(),

            // spacer(),

            SizedBtn(
              nextFunction: () {
                funds();
              },
              bgColor: kLightBrown,
              title: kOrder.toUpperCase(),
            ),

            spacer(),
          ]))));
  }

  Future<void> funds() async {
    //adding the delivery and total together
    var addTotal = VariablesOne.deliveryFee + Variables.grandTotal;
_timer.cancel();

    /*check if customer has order amount in its wallet*/

    if (Variables.currentUser[0]['mp'] == kCard) {

      //check if user have added his card
      if((Variables.currentUser[0]['ccn'] == null) ||

          (Variables.currentUser[0]['ccv'] == null) ||
          (Variables.currentUser[0]['cyr'] == null) ||
          (Variables.currentUser[0]['cmt'] == null)){
        VariablesOne.notifyErrorBot(title: 'Please add your card');
        VariablesOne.checkPayment = true;
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethods()));

      }else{
      getCloseVendor();
      }
    } else if (Variables.currentUser[0]['mp'] == kCash) {
      //getCloseVendorWithCash();
      getCloseVendor();
    } else if (Variables.currentUser[0]['mp'] == kWallet) {
      //check if wallet is up to amount of gas amount
      if (Variables.currentUser[0]['wal'] >= addTotal) {
        getCloseVendor();
      } else {
        //let the user know that his wallet balance is low
          payType = 'wallet';
        walletIsLow(payType);
      }
    }else if(Variables.currentUser[0]['mp'] == kPromo){
      if (Variables.currentUser[0]['refact'] >= addTotal) {
        getCloseVendor();
      } else {
        payType = 'promo account';
        walletIsLow(payType);
      }
    }

    /*function for moving to next vendor*/
  }

  Future<void> getCloseVendor() async {
    setState(() {
      _publishModal = true;
    });
    // ignore: close_sinks
    var radius = BehaviorSubject<int>.seeded(Variables.radius!);

    /*check if kg booked is more than 12.5 or quantity of cylinder is more than 5*/

    if( VariablesOne.doubleOrder == true){
      sumQty =  Variables.cylinderCount + Variables.cylinderCountSecond;

    }else{
      sumQty =  Variables.cylinderCount;
    }
    if ((sumQty >= 3) || Variables.totalGasKG >= 15) {
      print('greattttttttttt');
/*match with vendor that has motor*/
      Variables.matchedVendorDoc.clear();
      Variables.customerData.clear();      
      //getting vendor that is close
try{
//getting the vendor that has money in his wallet

  final QuerySnapshot result = await FirebaseFirestore.instance

      .collectionGroup("companyVendors")
      .where('wal', isGreaterThanOrEqualTo: p1.round())
      .where('ol', isEqualTo: true)
      .where('appr', isEqualTo: true)
      .where('tr', isEqualTo: false)
      .where('mt', isEqualTo: 'vehicle')
      .get();

  final List <DocumentSnapshot> documents = result.docs;
  if (documents.length == 0) {
    setState(() {
      _publishModal = false;
    });
    getCustomerWaiting();

  } else {

    for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data =  document.data() as Map<String, dynamic>;
      id.add(data['vId']);
    }


//get vendor that is close

    var ref = FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('appr', isEqualTo: true)
        .where('tr', isEqualTo: false)
        .where('ol', isEqualTo: true)
        .where('mt', isEqualTo: 'vehicle');
    GeoFirePoint center = geo.point(
        latitude: Variables.myPosition.latitude,
        longitude: Variables.myPosition.longitude);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center,
          radius: rad.toDouble(),
          field: 'vPos',
          strictMode: true);
    }).listen(_updateMarker);
  }

}catch(e){
  setState(() {
    _publishModal = false;
  });
  print('7777777$e');

  Fluttertoast.showToast(
      msg: kError,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      backgroundColor: kBlackColor,
      textColor: kRedColor);
}



    } else {
      print('lesssssssssss');

      try{
      /*the booked gas is less than 12.5 and quantity is less 5*/
        final QuerySnapshot result = await FirebaseFirestore.instance

            .collectionGroup("companyVendors")
            .where('ol', isEqualTo: true)
            .where('appr', isEqualTo: true)
            .where('tr', isEqualTo: false)

            .get();

        final List <DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          setState(() {
            _publishModal = false;
          });
          print('111111111');
          getCustomerWaiting();

        } else {

          for (DocumentSnapshot document in documents) {
            Map<String, dynamic> data =  document.data() as Map<String, dynamic>;
            id.add(data['vId']);
          }


//get vendor that is close

          var ref = FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('appr', isEqualTo: true)
              .where('tr', isEqualTo: false)
              .where('ol', isEqualTo: true);
          GeoFirePoint center = geo.point(
              latitude: Variables.myPosition.latitude,
              longitude: Variables.myPosition.longitude);

          // subscribe to query
          subscription = radius.switchMap((rad) {
            return geo.collection(collectionRef: ref).within(
                center: center,
                radius: rad.toDouble(),
                field: 'vPos',
                strictMode: true);
          }).listen(_updateMarker);
        }
    }catch(e){
        print('7777777$e');
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }

  void _updateMarker(List<DocumentSnapshot> documentList) {
    subscription.cancel();
    documentList.forEach((DocumentSnapshot document) async {
      idSecond.add(document['vId']);
    });
    if ((id.length == 0) || (idSecond.length == 0)) {

      ///getting the customer waiting for next vendor if there is no vendor avalible
      print('222222222');

      getCustomerWaiting();
      setState(() {
        _publishModal = false;
      });
    } else {

      final intersectedCollection = id.intersection(idSecond); // [5]
      Variables.matchedVendorDoc = intersectedCollection;

      getMatchedVendor();



    }
  }

  Future<void> getMatchedVendor() async {
    if (Variables.matchedVendorDoc.length == 0) {

      getCustomerWaiting();


    } else {

      setState(() {
        _publishModal = true;
        Variables.bookingDate = DateTime.now();
      });
try{
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
          .get()
          .then((value) {
        value.docs.forEach((result) async {
         setState(() {
           Variables.customerData.clear();
           Variables.customerData.add(result.data());
         });


         /*get the time and distance it will take to cover the distance*/
          try{
         String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.customerData[0]['lat']},${Variables.customerData[0]['log']}&destinations=$lat,$log&departure_time=now&key=${Variables.myKey}";

         http.Response res = await http.get(Uri.parse(url));

         if(res.statusCode == 200){
           Map<String, dynamic> mapItems = json.decode(res.body);

           var videos = mapItems['rows']; //returns a List of Maps
           for (var item in videos) { //iterate over the list
             Map myMap = item; //store each map
             final items = (myMap['elements'] as List).map((i) =>
                 Matrix.fromJson(i));
             for (final item in items) {
               Variables.timeTaken = item.traffic['text'];
               Variables.timeTakenValues = item.traffic['value'];
               Variables.distance = item.distance['text'];

             }
           }

         }else{
           Variables.timeTaken = '5';
           Variables.timeTakenValues = '10';
           Variables.distance = '4.0';
         }
          }catch(e){

          }

         if (checkDate == true) {
           //delivery of gas is now
           /*send the customer data to the vendor*/
           FirebaseFirestore.instance
               .collection('customer')
               .doc(Variables.customerData[0]['vId'])
               .set({
             'fn': Variables.userFN!,
             'ln': Variables.userLN,
             'px': Variables.userPix,
             'ph': Variables.buyerMobileNumber,
             'ad': Variables.buyerAddress,
             'cud': Variables.userUid, //customer uid
             'ud': Variables.userUid,
             'pos': point.data,
             'la': lat,
             'lg': log,
             'gas':Variables.matchedBusiness['gas'],
             //new cylinder number
             'vf':false,
             'gv':false,
             'cKG': Variables.kGItems,
             'cQ': Variables.headQuantityText,
             'ca':sumQty,
             'gk':Variables.totalGasKG,
             'cKG2': Variables.secondKGItems,
             'nam': Variables.selectedAmount,
             'by':Variables.buyCylinder,
             're':Variables.checkRent,
             'pz':Variables.checkRent?Variables.selectedAmount:'',
             'amt': Variables.grandTotal + VariablesOne.deliveryFee,
             'aG': Variables.gasEstimatePrice,
             'acy': Variables.sumCylinder, //amount cylinder
             'tc': Variables.totalCylinder,

             'mp': Variables.currentUser[0]['mp'],
             'dd': Variables.selectedDate,
             'ts': now,
             'bgt': Variables.buyingGasType,

             'wd': checkDate ? 'Now' : 'Later',
             'tm': "5mins",//Variables.timeTaken,
             'dt': Variables.distance,


             'df': VariablesOne.deliveryFee,
             'cm':Variables.matchedBusiness['biz'],
             'ga':Variables.matchedBusiness['add'],
             'gd':Variables.matchedBusiness['id'],
             'ci': VariablesOne.subLocality,
             'trw':kUnknown,
             'ew':kUnknown,
             'uo':false,


             'vl':Variables.customerData[0]['lat'],
             'vlo':Variables.customerData[0]['log'],
             'wkm': Jiffy().week,
             'yr': DateTime.now().year,
             'mth': DateTime.now().month,
             'day': DateTime.now().day,
             'tms': DateFormat('h:mm a').format(DateTime.now()),
             'td': formattedDate,
             'wk': DateTime.now().weekday,
             'date': "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",

             //'cid': customerData[0]['vId'],
             'del': false,
             'can': false, //deli

             'vid': Variables.customerData[0]['vId'],
             'vfn': Variables.customerData[0]['fn'],
             'vln': Variables.customerData[0]['ln'],
             'vem': Variables.customerData[0]['email'],
             'vpi': Variables.customerData[0]['pix'],
             'vph': Variables.customerData[0]['ph'],
             'biz': Variables.matchedBusiness['biz'],
             'cbi': Variables.matchedBusiness['ud'],

             //new cylinder number
             'tt': "5mins"//Variables.timeTaken, //time taken to deliver
           });

/*update the vendor database connection to true*/


           FirebaseFirestore.instance
               .collectionGroup('companyVendors')
               .where('vId', isEqualTo: Variables.customerData[0]['vId'])
               .get()
               .then((value) {
             value.docs.forEach((res) {
               res.reference.set({
                 'con': true,
                 'cuid': Variables.userUid //should be added by the vendor
               },SetOptions(merge: true));
             });
           });


             //listen if vendor picked the call


           subscription = FirebaseFirestore.instance
                 .collectionGroup('companyVendors')
                 .where('vId', isEqualTo: Variables.customerData[0]['vId'])
                 .snapshots()
                 .listen((result) {
               if ((result.docs[0]['ac'] == Variables.vendorAccept) &&
                   (result.docs[0]['cuid'] == Variables.userUid)) {
                 Constant1.checkPickedCall = true;
                      /*check if customer cancelled the order*/

                 FirebaseFirestore.instance
                     .collection("customer")
                     .doc(Variables.customerData[0]['vId'])
                     .snapshots()
                     .listen((result) {
                   if (result.data()!['can'] == true) {


                     setState(() {
                       Variables.matchedVendorDoc.remove(Variables.matchedVendorDoc[0]);
                     });
                    askToContinue();
                   }
                 });
                 setState(() {
                   _publishModal = false;
                   if(subscription != null){
                     subscription.cancel();

                   }
                 });
                 /*if the vendor accept the booking redirect the customer*/
                 Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ConnectVendor()));

                 setState(() {
                   _publishModal = false;
                 });
               } else {
                 /*rematch the customer to next vendor after 20 seconds if the vendor did not accept booking*/
                 Future.delayed(const Duration(seconds: kCallDuration), () {
                   if(Constant1.checkPickedCall == false){
                     FirebaseFirestore.instance
                         .collectionGroup('companyVendors')
                         .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
                         .get()
                         .then((value) {
                       value.docs.forEach((result) {
                         result.reference.update({
                           'con': false,
                         });
                       });
                     });
/*change the missed vendor con to true*/

                     setState(() {
                       Variables.matchedVendorDoc
                           .remove(Variables.customerData[0]['vId']);
                     });
                     /*removing the  vendor*/

                     getMatchedVendor();
                   }

                 });
               }
             });

         } else {
/*this is an upcoming booking*/
           getUpcomingBookings();
         }
        });
      });



    }catch(e){
print('333333333$e');
  setState(() {
    _publishModal = false;
  });
  Fluttertoast.showToast(
      msg: kError,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      backgroundColor: kBlackColor,
      textColor: kRedColor);
}
    }
  }

  void getUpcomingBookings() {
    /*this is an upcoming booking*/
    setState(() {
      _publishModal = true;
    });


    try {
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
          .get()
          .then((value) {
        value.docs.forEach((result) {
          result.reference.set({
            'acu':false,//accepting upcoming
            'ue': true,
            'dv':Variables.selectedDate.toString(),
            'uuid': Variables.userUid //should be added by the vendor
          },SetOptions(merge: true));
        });
      });

            subscription = FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: Variables.customerData[0]['vId'])
            .snapshots()
            .listen((result) {
            if ((result.docs[0]['acu'] == true) &&
                result.docs[0]['uuid'] == Variables.userUid) {
              Constant1.checkPickedCall = true;
              /*getting the upcoming booking details for vendor*/
              upcomingDetails();

              /*move the customer to see matched vendor details*/
              setState(() {
                _publishModal = false;
                if(subscription != null){
                  subscription.cancel();
                }
              });
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: CustomerUpcomingScreen()));
            } else {
/*rematch the customer to next vendor after 20 seconds if the vendor did not accept booking*/
              Future.delayed(const Duration(seconds: kCallDuration), () {
                if (Constant1.checkPickedCall == false) {
                  FirebaseFirestore.instance
                      .collectionGroup('companyVendors')
                      .where('vId', isEqualTo: Variables.customerData[0]['vId'])
                      .get()
                      .then((value) {
                    value.docs.forEach((result) {
                      result.reference.update({
                        'ue': false,
                      });
                    });
                  });
                  /*rematch the customer to another customer for upcoming bookings*/
                  setState(() {
                    Variables.matchedVendorDoc.remove(
                        Variables.matchedVendorDoc[0]);
                  });
                  getMatchedVendor();
                }
              });
            }

        });
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  void upcomingDetails() {
    try {
      /*push to the vendor database*/

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Upcoming')
          .doc();
      documentReference.set({
        'doc': documentReference.id,
        'day':  DateFormat('d').format(Variables.selectedDate),
        'mth': DateFormat('MM').format(Variables.selectedDate),
        'yr': DateFormat('yyyy').format(Variables.selectedDate),


        'vl':Variables.customerData[0]['lat'],
        'vlo':Variables.customerData[0]['log'],
        'vid': Variables.customerData[0]['vId'],
        'vfn': Variables.customerData[0]['fn'],
        'vln': Variables.customerData[0]['ln'],
        'vem': Variables.customerData[0]['email'],
        'vpi': Variables.customerData[0]['pix'],
        'vph': Variables.customerData[0]['ph'],
        'biz': Variables.matchedBusiness['biz'],
        'cbi': Variables.matchedBusiness['ud'],
        'ad': Variables.buyerAddress,
        'gas':Variables.matchedBusiness['gas'],

        'dl': false,
        'tm': Variables.timeTaken, //time taken to deliver
        'uo':false,

        //new cylinder number
        'pz':Variables.checkRent?Variables.selectedAmount:'',
        'tc': Variables.totalCylinder,
        'trw':kUnknown,
        'ew':kUnknown,

        'vf':false,
        'gv':false,
        'cKG': Variables.kGItems,
        'cQ': Variables.headQuantityText,
        'ca':sumQty,
        'gd':Variables.matchedBusiness['id'],
        'gk':Variables.totalGasKG,
        'cKG2': Variables.secondKGItems,
        'nam': Variables.selectedAmount,
        'by':Variables.buyCylinder,
        're':Variables.checkRent,
        'amt': Variables.grandTotal + VariablesOne.deliveryFee,
        'aG': Variables.gasEstimatePrice,
        'acy': Variables.sumCylinder, //amount cylinder

        'bgt': Variables.buyingGasType,

        'df': VariablesOne.deliveryFee,
        'cm':Variables.matchedBusiness['biz'],
        'ga':Variables.matchedBusiness['add'],
        'fn': Variables.userFN!,
        'ln': Variables.userLN,
          'ud':Variables.userUid,
        'px': Variables.userPix,
        'cud': Variables.userUid,
        'ph': Variables.buyerMobileNumber,

        'pos': point.data,
        'la': lat,
        'lg': log,
        'bz': Variables.matchedBusiness['biz'],
        'ci': VariablesOne.subLocality,
        'st': Variables.administrative,
        'cty': Variables.country,

        //new cylinder number
        'tt': Variables.timeTaken,
        'mp': Variables.currentUser[0]['mp'],
        'dd': Variables.selectedDate.toString(),
        'ts': now,
        'dt': Variables.distance
      });

      VariablesOne.upcomingDocId = documentReference.id;
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }



  void getCustomerWaiting() {
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OneCountDownTimer()));

  }


  void walletIsLow(String payType) {


    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        title: Column(
          children: [

            Center(
              child: TextWidget(
                name: 'Insufficient funds'.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Dear ${Variables.userFN!.trim()}, your $payType balance is insufficient, Please kindly choose another payment method. Thanks.',
              textAlign: TextAlign.center,

              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.w400,
                color: kTextColor,
                fontSize: ScreenUtil().setSp(kFontSize,
                ),
            ),
          )),

          Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              child: NewBtn(nextFunction: (){
                Navigator.pop(context);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethods()));

              }, bgColor: kLightBrown, title: 'Payment Methods')),



        ]
    ));


  }

  void askToContinue() {
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CancellingBooking(no: (){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreenSecond(),
          ),
              (route) => false,
        );


      },

      yes: (){
      Navigator.pop(context);
      getMatchedVendor();},
      )


      ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => CancellingBooking(no: (){
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreenSecond(),
            ),
                (route) => false,
          );


        },

        yes: (){
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: RipplesAnimation()));
          getMatchedVendor();},
        )
    );

  }}
