import 'dart:io';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/upcoming_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/show_upcomings.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/analysis_tab.dart';
import 'package:easy_homes/admins/pages/tabs/count_tab.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/show_prize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';
class EasyUpcoming extends StatefulWidget {
  @override
  _EasyUpcomingState createState() => _EasyUpcomingState();
}

class _EasyUpcomingState extends State<EasyUpcoming> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingOrders();
  }
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }
bool progress = false;
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];


  bool _loadMoreProgress = false;
  var _lastDocument;
 late  DocumentSnapshot result;
  bool moreData = false;
  @override
  Widget build(BuildContext context) {

    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(

            height: MediaQuery.of(context).size.height * kModalHeight,
            child:itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
            itemsData.length == 0 && progress == true ?
            NoWorkError(title: kUpComingError,)
                : SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                StickyHeader(
                header:  AdminHeader(title: kUpcoming,),


                content:   ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _documents.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextWidget(
                                  name:"${itemsData[index]['fn']} ${itemsData[index]['ln']}",
                                  textColor: kLightBrown,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w500,
                                ),

                                TextWidget(
                                  name:  itemsData[index]['email'],
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w500,
                                ),
                                Divider(),
                                Row(

                                  children: <Widget>[
                                    VendorPix(pix: itemsData[index]['pix'] ,pixColor: Colors.transparent,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[



                                        GestureDetector(
                                          onTap:() async {
                                            var url = "tel:${ itemsData[index]['ph']}";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },

                                          child: TextWidget(
                                            name:  itemsData[index]['ph'],
                                            textColor: kDoneColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),

                                        TextWidget(
                                          name:  itemsData[index]['date'],
                                          textColor: kDarkRedColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.w500,
                                        ),



                                      ],
                                    ),


                                    Spacer(),

                                    AdminConstants.category == AdminConstants.partner!.toLowerCase()?Text(''):

                                    itemsData[index]['bl'] == true?Text(''):ElevatedButton(
                                      onPressed: (){

                                        //verifyBlock(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: kLightBrown,
                                      ),

                                      child: TextWidget(
                                        name: 'Block',
                                        textColor: kWhiteColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),

                                space(),
                                Divider(),
                                Text("Biz Name".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxanium(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil()
                                        .setSp(kFontSize14, ),
                                    color: kDoneColor,
                                  ),
                                ),

                                TextWidget(
                                  name: '${itemsData[index]['biz']}'.toUpperCase(),
                                  textColor: kTextColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                space(),

                                Text("Biz Address".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxanium(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil()
                                        .setSp(kFontSize14, ),
                                    color: kDoneColor,
                                  ),
                                ),

                                TextWidget(
                                  name: '${itemsData[index]['add']}'.toUpperCase(),
                                  textColor: kTextColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),

                                AdminConstants.category == AdminConstants.owner!.toLowerCase()
                                    ?Row(children: [


                                  MoneyFormatColors(
                                    color: kSeaGreen,
                                    title: TextWidget(
                                      name: VariablesOne.numberFormat.format(itemsData[index]['wal']).toString(),
                                      textColor: kSeaGreen,
                                      textSize: kFontSize,
                                      textWeight: FontWeight.w500,
                                    ),
                                  ),


                                  Spacer(),
                                  ShowPrizeTwo(title:kGasP2,prize:itemsData[index]['gas'],click: (){})

                                ],):Text('')
                              ],
                            ),
                          ),
                        );
                      }
                  ),
            ),

                  progress == true || _loadMoreProgress == true
                      || _documents.length < Variables.limit
                      ?Text(''):
                  moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                      onTap: (){loadMore();},
                      child: SvgPicture.asset('assets/imagesFolder/load_more.svg',))



                ]
            ))));
  }
  Future<void> getUpcomingOrders() async {
    final QuerySnapshot data = await FirebaseFirestore.instance.collection("AllBusiness")
        .where('ol',isEqualTo: true)
        
        .limit(Variables.limit)

        .get();
    final List<DocumentSnapshot> documents = data.docs;


    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    }else{
      for ( result in documents) {
        _lastDocument = documents.last;
        setState(() {
          /* _documents.clear();
          itemsData.clear();*/


          _documents.add(result);
          itemsData.add(result.data());
          //print(itemsData);
        });
      }
    }
  }


  Future<void> loadMore() async {

    final QuerySnapshot data = await FirebaseFirestore.instance.collection("AllBusiness")
        .where('ol',isEqualTo: true)
       
       .startAfterDocument(_lastDocument).limit(Variables.limit)

        .get();
    final List <DocumentSnapshot> documents = data.docs;

    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (result in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(result);
          itemsData.add(result.data());

          moreData = false;


        });
      }
    }
  }

}
