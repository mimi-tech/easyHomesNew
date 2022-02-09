import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/business_cancel.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/business_comments.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/cancel_order.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/comment.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_cancelOrder.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_comments.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/verify_vendor.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/vendorReg/screens/home.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class PageAddVendor extends StatefulWidget {
  PageAddVendor({
    required this.rating,
    required this.cancel,
    required this.addVendor,
    required this.block,
     this.users,

  });

  final Color rating;
  final Color cancel;
  final Color addVendor;
  final Color block;
  final Color? users;

  @override
  _PageAddVendorState createState() => _PageAddVendorState();
}

class _PageAddVendorState extends State<PageAddVendor> {
  var currentDate = DateTime.now();
  bool status = false;


  Widget blockUsers() {
    if (AdminConstants.category == AdminConstants.owner!.toLowerCase()) {
      return Badge(
        badgeContent: TextWidget(
          name:  PageConstants.blockedUsers.length.toString(),
          textColor: kWhiteColor,
          textSize: kFontSize14,
          textWeight: FontWeight.bold,
        ),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: kBadgeMargin),
            child: SvgPicture.asset('assets/imagesFolder/block.svg',
            color: widget.block,
            )
        ),
        toAnimate: true,
        badgeColor: kRedColor,
        shape: BadgeShape.circle,
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
      );
    }else{
      return Text('');
    }
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: kDarkBlue,
          height: 56.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              GestureDetector(
                  onTap: () {
    if (AdminConstants.category == AdminConstants.owner!.toLowerCase()) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: OwnerScreen()));
    }else if  (AdminConstants.category == AdminConstants.partner!.toLowerCase()){
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: PartnerScreen()));
    }else if (AdminConstants.category == AdminConstants.business.toLowerCase()) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: BusinessScreen()));

    }else if ((AdminConstants.categoryType == AdminConstants.owner!.toLowerCase()) && (AdminConstants.category == AdminConstants.admin.toLowerCase())) {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: OwnerScreen()));
                    }else if  ((AdminConstants.categoryType == AdminConstants.partner!.toLowerCase()) && (AdminConstants.category == AdminConstants.admin.toLowerCase())){
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: PartnerScreen()));
                    }else if ((AdminConstants.categoryType == AdminConstants.business.toLowerCase()) && (AdminConstants.category == AdminConstants.admin.toLowerCase())) {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: BusinessScreen()));

                    }


                  },
                  child: SvgPicture.asset('assets/imagesFolder/home.svg',color: widget.block,)),

              GestureDetector(
                  onTap: () {
                    //check admin category

                    //if (AdminConstants.category == AdminConstants.owner!.toLowerCase()) {


                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              child: EasyComment()));


                   /* } else{
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              child: BusinessComment()));
                    }*/
                  },
                  child: SvgPicture.asset('assets/imagesFolder/rating.svg',color: widget.rating,)),

                 GestureDetector(
                     onTap: (){

                       Navigator.push(
                           context,
                           PageTransition(
                               type: PageTransitionType.scale,
                               alignment: Alignment.bottomCenter,
                               child: AllUsers()));
                     },

                     child: Icon(Icons.verified_user,color: widget.users,)),


            GestureDetector(
                  onTap: () {
                    //check admin category
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              child: EasyCancelOrder()));


                  },
                  child: SvgPicture.asset('assets/imagesFolder/block.svg',
                    color: widget.cancel,
                  )),

              GestureDetector(
                  onTap: () {
                    setState(() {
                      AdminConstants.appliedColor = true;
                    });
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: AppliedVendors()));
                  },
                  child: SvgPicture.asset(
                    'assets/imagesFolder/add_user.svg',color: widget.addVendor,
                  )
              ),



            ],
          ),
        ));
  }

  Future<void> getBlockedUsers() async {
    PageConstants.blockedUsers.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection(
        'userReg').where('bl',isEqualTo: Variables.block).get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {
          PageConstants.blockedUsers.add(document.data());

        });
      }
    }
  }
}

class TotalAmount extends StatefulWidget {
  TotalAmount({required this.name, required this.day});

  final dynamic name;
  final dynamic day;

  @override
  _TotalAmountState createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: kBottomColor,
          height: 56.h,
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 2),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    TextWidget(
                      name: 'Total Amount: ',
                      textColor: kHintColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    MoneyFormatColors(
                      color: kWhiteColor,
                      title: TextWidget(
                        name: widget.name,
                        textColor: kWhiteColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    TextWidget(
                      name: 'Total Order: ',
                      textColor: kHintColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      name: widget.day,
                      textColor: kWhiteColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          )




          /* Center(
              child: RichText(
            text: TextSpan(
                text: (widget.day),
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w400,
                  fontSize:
                      ScreenUtil().setSp(kFontSize, ),
                  color: kHintColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.name,
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kWhiteColor,
                    ),
                  )
                ]),
          )),*/
        ));
  }
}
