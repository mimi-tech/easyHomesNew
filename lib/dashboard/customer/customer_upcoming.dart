import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/show_customer_bookings.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
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
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
class CustomerUpcomingBookings extends StatefulWidget {
  @override
  _CustomerUpcomingBookingsState createState() => _CustomerUpcomingBookingsState();
}

class _CustomerUpcomingBookingsState extends State<CustomerUpcomingBookings> {
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  bool _publishModal = false;
  bool progress = false;
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }
late DocumentSnapshot document;

  bool showDelivered = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(

        appBar: PlatformAppBar(
          backgroundColor: kLightBrown,
          title: TextWidgetAlign(
            name: kUpcoming.toUpperCase(),
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),
        ),
        body: ModalProgressHUD(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
          child: Column(
              children: <Widget>[

                space(),
                itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                itemsData.length == 0 && progress == true ?  Center(
                  child: TextWidgetAlign(
                    name: 'No upcoming order',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,),

                ):  ListView.builder(
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
                                  //VariablesOne.documentData = document;
                                  Variables.transit = _documents[index];

                                  final value = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShowCustomerBookingDetails()),
                                  );

                                  if (value != null && value == 'Done') {

                                    getUpcomingOrders();

                                  }

                                },
                                child: Row(

                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          SvgPicture.asset('assets/imagesFolder/calendar.svg',),
                                        ],
                                      ),
                                      space(),
                                      SizedBox(width:10.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextWidget(
                                            name:'${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['dd']))}' ,
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,),

                                          TextWidget(
                                            name:'From: ${itemsData[index]['vfn']} ${itemsData[index]['vln']}' ,
                                            textColor: kRadioColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w400,),


                                          Container(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: ScreenUtil()
                                                    .setWidth(250),
                                                minHeight: ScreenUtil()
                                                    .setHeight(20),
                                              ),
                                              child: ReadMoreText(
                                                'To: ${itemsData[index]['ad']}' ,
                                                //doc.data['desc'],
                                                trimLines: 1,
                                                colorClickableText: kLightBrown,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' ...',
                                                trimExpandedText: '  less',
                                                style: GoogleFonts.oxanium(
                                                  fontSize: ScreenUtil().setSp(kFontSize14, ),
                                                  color: kRadioColor,

                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(

                                        children: <Widget>[
                                          SvgPicture.asset('assets/imagesFolder/back_right.svg'),
                                        ],
                                      ),


                                    ]
                                ),
                              )
                          ),
                        ),
                      );
                    }
                )
              ]
          )
      ),
    )
    )
    );
  }

  Future<void> getUpcomingOrders() async {
    itemsData.clear();
    final QuerySnapshot result = await   FirebaseFirestore.instance.collection("Upcoming")
        .where('cud', isEqualTo:Variables.userUid )
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .get();
    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for ( document in documents) {
        setState(() {
         /* _documents.clear();
          itemsData.clear();*/
          _documents.add(document);
          itemsData.add(document.data());
          VariablesOne.documentData = document;
        });

      }

    }
  }

}
