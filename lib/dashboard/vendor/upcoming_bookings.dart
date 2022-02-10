import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/cancel_order.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/show_booking.dart';
import 'package:easy_homes/dashboard/vendor/show_bookings_second.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class UpcomingBookings extends StatefulWidget {
  @override
  _UpcomingBookingsState createState() => _UpcomingBookingsState();
}

class _UpcomingBookingsState extends State<UpcomingBookings> {
  bool _publishModal = false;

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }

  bool progress = false;
  bool showDelivered = true;
late DocumentSnapshot document;

   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcoming();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kWhiteColor,
              iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidgetAlign(
                    name: kUpcoming.toUpperCase(),
                    textColor: kLightBrown,
                    textSize: 20,
                    textWeight: FontWeight.bold,
                  ),

                ],
              ),
            ),
            body: ProgressHUDFunction(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 10,),
                    itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                    itemsData.length == 0 && progress == true ?  Center(
                      child: TextWidgetAlign(
                        name: 'No upcoming order',
                        textColor: kLightBrown,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,),

                    ):
                    ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _documents.length,
                    itemBuilder: (context, int index) {


                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top:18.0,bottom: 18.0),
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: GestureDetector(
                                onTap: () async {
                                  Variables.transit = _documents[index];
                                  final value = await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ShowBookingsSecond()),);


                                },
                                child: Row(children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/imagesFolder/calendar.svg',
                                      ),
                                    ],
                                  ),
                                  space(),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          TextWidget(
                                            name: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['dd']))} by ${DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['dd']))}',
                                            textColor: kTextColor,
                                            textSize: 14,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      TextWidget(
                                        name: 'From: ${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                                        textColor: kRadioColor,
                                        textSize: kFontSize14,
                                        textWeight: FontWeight.w400,
                                      ),
                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().setWidth(250),
                                            minHeight: ScreenUtil().setHeight(20),
                                          ),
                                          child: ReadMoreText(
                                            'To: ${itemsData[index]['ad']}',
                                            //doc.data['desc'],
                                            trimLines: 1,
                                            colorClickableText: kLightBrown,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' ...',
                                            trimExpandedText: '  less',
                                            style: GoogleFonts.oxanium(
                                              fontSize: ScreenUtil().setSp(
                                                  kFontSize14,
                                                  ),
                                              color: kRadioColor,
                                            ),
                                          ),
                                        ),
                                      ),],
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios)
                                ]),
                              )),
                        ),
                      );
                    })
              ])),
            )));
  }

  Future<void> delivered(int index) async {
    /*update the customer user Reg ub -> upcoming booking  to true*/

    setState(() {
      _publishModal = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('userReg')
          .doc(itemsData[index]['ud'])
          .set({
        'ub': false,
        'ubd': itemsData[index]['doc'] //the document id
      },SetOptions(merge: true));

      //update the vendor upcoming bookings dl to true
      await FirebaseFirestore.instance
          .collection('Upcoming')
          .doc(itemsData[index]['doc'])
          .update({
        'dl': true,
      });
      setState(() {
        _publishModal = false;
      });

      Fluttertoast.showToast(
          msg: kUpcomingToast,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    } catch (e) {
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

  Future<void> getUpcoming() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('Upcoming')
        .where('vid', isEqualTo:Variables.userUid )
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
setState(() {
  progress = true;
});
    } else {

       for (document in documents) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          _documents.add(document);
          itemsData.add(document.data());

        });
      }}

  }
}
