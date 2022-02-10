import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/confirmation/bottom_modal.dart';
import 'package:easy_homes/confirmation/rate_vendor.dart';
import 'package:easy_homes/dashboard/customer/dashboard_page.dart';
import 'package:easy_homes/dashboard/customer/ongoing_map.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/customer_edit_order.dart';
import 'package:easy_homes/extacted_classes/map_info.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/customer_cancel.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingOrder extends StatefulWidget {
  @override
  _OngoingOrderState createState() => _OngoingOrderState();
}

class _OngoingOrderState extends State<OngoingOrder> {
  bool _publishModal = false;
  bool progress = false;
late DocumentSnapshot document;
  AudioPlayer audioPlayer = AudioPlayer();

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }


  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.01);
  }


  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;
  LatLng sourceLocation = LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude);
  LatLng destLocation = LatLng(DashboardConstants.ongoingOrders[0]['vl'], DashboardConstants.ongoingOrders[0]['vlo']);

  late  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
// this set will hold my markers
  Set<Marker> _markers = {};
// this will hold the generated polylines
  Set<Polyline> _polylines = {};
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = Variables.myKey;
// for my custom icons
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  bool checkDate = Variables.selectedDate.isBefore(DateTime.now());
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
 bool checkService = false;


  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');
    //final BitmapDescriptor sourceIcon = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);
    //destinationIcon = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/dest.png');
  }

  // Calculating to check that
  // southwest coordinate <= northeast coordinate


  void onMapCreated(GoogleMapController controller) {
    //controller.setMapStyle(Utils.mapStyles);

    _controller.complete(controller);


    setMapPins();
    //setPolyLines();

  }

  void setMapPins() {
    setState(()  {

      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: sourceLocation,
        icon: sourceIcon,
        flat: true,
        anchor: Offset(0.5, 0.5),

      ),


      );
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destLocation,
        icon: destinationIcon,
        //icon: BitmapDescriptor.defaultMarker,
        flat: true,
        anchor: Offset(0.5, 0.5),

      ));
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();
    gettingVendorConfirm();


  }
  int deliveryFee = 0;
  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      zoom: cameraZoom,
      bearing: cameraBearing,
      tilt: cameraTilt,
      target: sourceLocation,

    );


    return SafeArea(child: Scaffold(

        body: ProgressHUDFunction(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
                child:
                Column(

                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[

                        Container(
                          child: SvgPicture.asset(
                            'assets/imagesFolder/call_bg.svg',
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            //height: MediaQuery.of(context).size.height*1.5,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: 'Gas '.toUpperCase(),//('${Variables.customerData.first['biz']}...'.toUpperCase()),
                                        style: GoogleFonts.oxanium(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(kFontSize,
                                              ),
                                          color: kWhiteColor,
                                        ),

                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Vendor'.toUpperCase(),
                                            style: GoogleFonts.oxanium(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(
                                                  kFontSize,
                                                  ),
                                              color: kLightBrown,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.cancel,color: kWhiteColor,size: 30,)),
                                ],
                              ),
                              space(),
                              TextWidget(
                                name: '${DashboardConstants.ongoingOrders[0]['dt']} ( ${DashboardConstants.ongoingOrders[0]['tm']} )',
                                textColor: kYellow,
                                textSize: kFontSize,
                                textWeight: FontWeight.w400,
                              ),
                              space(),
                              TextWidget(
                                name: DashboardConstants.ongoingOrders[0]['vfn'],
                                textColor: kWhiteColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.bold,
                              ),


                              TextWidget(
                                name: DashboardConstants.ongoingOrders[0]['vln'],
                                textColor: kWhiteColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.bold,
                              ),

                              space(),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 40.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(

                                        color: kLightBrown,

                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(kContainerRadius),
                                            bottomLeft: Radius.circular(kContainerRadius),
                                            /*topLeft: Radius.circular(10),*/
                                            bottomRight: Radius.circular(kContainerRadius)
                                        )
                                    ),


                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/imagesFolder/star.svg',),

                                        TextWidgetAlign(
                                          name: 2.5.toString(),
                                          textColor: kWhiteColor,
                                          textSize: kFontSize,
                                          textWeight: FontWeight.bold,
                                        ),


                                      ],
                                    ),


                                  ),

                                  SizedBox(width: 20.w,),

                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(

                                        imageUrl: DashboardConstants.ongoingOrders[0]['vpi'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset('assets/imagesFolder/user.svg'),

                                        fit: BoxFit.cover,
                                        width: 55.w,
                                        height: 60.h,


                                      ),
                                    ),
                                  ),


                                ],
                              ),

                              SizedBox(height: 10.h,)


                            ],


                          ),
                        ),

                        Container(
                            margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 20),
                            alignment: Alignment.bottomRight,
                            child: checkService?

                            PopupMenuButton(

                                child: Icon(Icons.more_vert, color: kRadioColor,),

                                itemBuilder: (context) =>
                                [

                                  PopupMenuItem(
                                    child: GestureDetector(

                                      onTap: () {
                                        Navigator.pop(context);
                                        editOrder();
                                      },
                                      child: TextWidget(
                                        name: DashboardConstants.ongoingOrders[0]['by'] == true?'Confirm cylinder':kEditOrder,
                                        textColor: kTextColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.bold,
                                      ),

                                    ),
                                  ),


                                ]
                            )


                                :PopupMenuButton(

                                child: Icon(Icons.more_vert, color: kRadioColor,),

                                itemBuilder: (context) =>
                                [
                                  //ToDo:Edit details
                                 PopupMenuItem(
                                    child: GestureDetector(

                                      onTap: () {
                                        cancelOrder();
                                      },
                                      child: TextWidget(
                                        name: kCancelOrder,
                                        textColor: kTextColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.bold,
                                      ),

                                    ),
                                  ),

                                  PopupMenuItem(
                                    child: GestureDetector(

                                      onTap: () {
                                        Navigator.pop(context);
                                        editOrder();
                                      },
                                      child: TextWidget(
                                        name:  DashboardConstants.ongoingOrders[0]['by'] == true?'Confirm cylinder':kEditOrder,
                                        textColor: kTextColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.bold,
                                      ),

                                    ),
                                  ),


                                ]
                            )
                        )


                      ],
                    ),

                    /*displaying the vendor profile picture*/

                    Container(

                      height: MediaQuery.of(context).size.height *0.3,
                      width: MediaQuery.of(context).size.width ,
                      child: Stack(

                        children: <Widget>[
                          GoogleMap(
                              myLocationEnabled: true,

                              tiltGesturesEnabled: false,
                              markers: _markers,
                              polylines: _polylines,
                              mapType: MapType.normal,
                              initialCameraPosition: initialLocation,
                              onMapCreated: onMapCreated
                          ),

                          Positioned(
                              top: ScreenUtil().setSp(50),
                              left: 0,
                              right: 0,
                              child: MapInfoWindow(time: DashboardConstants.ongoingOrders[0]['tm'],address:DashboardConstants.ongoingOrders[0]['ci'])),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(

                          //color: kLightBrown,

                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(kContainerRadius),
                              topLeft: Radius.circular(kContainerRadius),

                            )

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[


                                GestureDetector(
                                    onTap: () async {
                                      var url = "tel:${DashboardConstants.ongoingOrders[0]['vph']}";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      'assets/imagesFolder/call.svg',)),

                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .scale,
                                            alignment: Alignment
                                                .bottomCenter,
                                            child: OngoingMap(doc:DashboardConstants.ongoingOrders[0]['vid'])));

                                  },
                                  child: SvgPicture.asset('assets/imagesFolder/dir2.svg',),
                                ),


                              ],
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/imagesFolder/gas_refill.svg',
                                  height: MediaQuery.of(context).size.height*0.1,
                                  width: MediaQuery.of(context).size.width*0.15,
                                ),
                                SizedBox(height: 10.h,),
                                TextWidgetAlign(
                                  name: 'Total Amount to be paid'.toUpperCase(),
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),
                                MoneyFormat(
                                  title: TextWidgetAlign(
                                    name: '${numberFormat.format(DashboardConstants.ongoingOrders[0]['amt'])}',
                                    textColor: kTextColor,
                                    textSize: kFontSize,
                                    textWeight: FontWeight.bold,
                                  ),
                                ),


                                TextWidgetAlign(
                                  name: checkDate?'Vendor arrives in ${DashboardConstants.ongoingOrders[0]['tm']}':
                                  'Sheduled date  ${DateFormat('EEEE, d MMM, yyyy').format(Variables.selectedDate)}'
                                  ,
                                  textColor: kTextColor,
                                  textSize: 16,
                                  textWeight: FontWeight.bold,
                                ),
                                TextWidgetAlign(
                                  name: checkDate?'':'Time: ${DateFormat('h:mm a').format(DashboardConstants.ongoingOrders[0]['dd'])}',
                                  textColor: kSeaGreen,
                                  textSize: 16,
                                  textWeight: FontWeight.bold,
                                ),

                                GestureDetector(

                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextWidgetAlign(
                                      name: kScreenedVendors.toUpperCase(),
                                      textColor: kRadioColor,
                                      textSize: kFontSize14,
                                      textWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                // SizedBtn(title: 'Confirm vendor',bgColor: kDoneColor,nextFunction: (){openConfirmBottom();},)

                              ],



                            )
                          ],
                        ),
                      ),
                    ),
                  ],

                )
            )
        )
    )
    );


  }







  void cancelOrder() {

    /*DateTime logOut = DateTime.now();



    var logOutTime =  DateFormat("hh:mm").format(logOut);
    var logInTime =  DateFormat("hh:mm").format(Variables.bookingDate);

    var format = DateFormat("hh:mm");
    var one = format.parse(logInTime);
    var two = format.parse(logOutTime);


    var hours = two.difference(one);
    int hoursCount = hours.inHours;
    int minutesCount = hours.inMinutes;
    var timeRemaining =  Variables.timeTaken - minutesCount;*/

    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS ?
        CupertinoAlertDialog(
          title: TextWidget(
            name: kCancelOrder.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          content: CustomerCancel(cancel1: kCancelOrderText,
            cancel2: DashboardConstants.ongoingOrders[0]['vfn'],
            cancel3: ' will deliver your gas before ',
            cancel4:  DashboardConstants.ongoingOrders[0]['tt'].toString(),),



          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                deleteOrder();
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name: kCancelOrder.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          )
          ,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: CustomerCancel(cancel1: kCancelOrderText,
                cancel2: DashboardConstants.ongoingOrders[0]['vfn'],
                cancel3: ' will deliver your gas before ',
                cancel4:  DashboardConstants.ongoingOrders[0]['tt']

              ),
            ),
            spacer(),
            YesNoBtn(no: (){Navigator.pop(context);},yes: (){deleteOrder();},),
          ],
        )

    );

  }

  void deleteOrder() {
    setState(() {
      _publishModal = true;
    });
    /*alert the vendor that order has been canceled by updating can to true*/
    try {
      /*update customer delivered to true in customer collection to remove ongoing order*/

      FirebaseFirestore.instance.collection('customer').doc(DashboardConstants.ongoingOrders[0]['vId']).set({
        'can': true,
        'del': true,
        //'gv':true,
      },SetOptions(merge: true));


      /*update vendor that order has been canceled*/

      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: DashboardConstants.ongoingOrders[0]['vid'])
          .get().then((value) {
        value.docs.forEach((result) {
          result.reference.update({
            //'can': true,
            'tr': false,
            'ac': "",
            'con': false,

          });
        });


      });




      /*update the user customer confirmation to true of current user*/
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).update({
        'uc':true,
        'del':true,

      });


      /*update vendor delivered to true in userReg collection*/

      FirebaseFirestore.instance.collection('userReg').doc(DashboardConstants.ongoingOrders[0]['vid']).update({

        'dl':true,

      });

      FirebaseFirestore.instance.collection('userReg').doc(DashboardConstants.ongoingOrders[0]['vid']).update({

        'dl':true,

      });
      setState(() {
        _publishModal = false;
      });
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );


      setState(() {
        _publishModal = false;
      });



    }catch (e){
      setState(() {
        _publishModal = false;

      });

      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);




    }
  }

  Future<void> gettingVendorConfirm() async {
//check when vendor confirms that gas has been delivered

    FirebaseFirestore.instance
        .collection("customer")
        .where('vid',isEqualTo:  DashboardConstants.ongoingOrders[0]['vid'])
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        if(result.data()['gv'] == true){
          setState(() {
            checkService  = true;
          });

          //notify the customer that gas has been given to the vendor

          getNotificationSound();
        }else{

        }
      });
    });

    FirebaseFirestore.instance
        .collection("userReg")
        .where('ud',isEqualTo: Variables.userUid)
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        if(result.data()['uc'] == false){
          openConfirmBottom();
        }else{

        }
      });
    });
  }
  Future<void> getNotificationSound() async {

    audioPlayer = await AudioCache().play("r3.mp3");
    Constant1.showRating(submit: (){audioPlayer.stop();},context: context);

    Future.delayed(const Duration(seconds: 10), () async {

      audioPlayer.stop();



    });
  }

  void openConfirmBottom() {

    /*show ios bottom modal sheet*/


    Constant1.checkPickedCall = false;

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: RateVendor()));




  }

  void editOrder() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerEditOrder()));

  }



}
