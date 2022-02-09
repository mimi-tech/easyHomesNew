import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';
class AllVendorPageDrawer extends StatefulWidget {
  @override
  _AllVendorPageDrawerState createState() => _AllVendorPageDrawerState();
}

class _AllVendorPageDrawerState extends State<AllVendorPageDrawer> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  double? rate;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child:   Container(
          height: MediaQuery.of(context).size.height,
          color: kDarkBlue,
          child:   Column(
            children: <Widget>[
              space(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap:() async {
                          var url = "tel:${PageConstants.getVendor[0]['ph']}";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: SvgPicture.asset('assets/imagesFolder/calla.svg',)),
                    Icon(Icons.more_vert,color: kHintColor,),
                  ],
                ),
              ),

              VendorPix(pix: PageConstants.getVendor[0]['pix'],pixColor: Colors.transparent,),
              space(),
              TextWidget(
                name: '${PageConstants.getVendor[0]['fn']} ${PageConstants.getVendor[0]['ln']} \n',
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),

              TextWidget(
                name: kVendor,
                textColor: kHintColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
              space(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextWidget(
                    name: PageConstants.getVendor[0]['rate'].toString(),
                    textColor: kHintColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                  RatingBar.builder(
                    initialRating: PageConstants.getVendor[0]['rate'],
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: kLightBrown,
                    ),
                    onRatingUpdate: (rating) {
                      rate = PageConstants.getVendor[0]['rate'];
                    },
                  ),
                ],
              ),

              space(),

              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal2),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: kHintColor,width: 0.2)
                ),
                child: Column(
                  children: <Widget>[
                    space(),
                    TextWidget(
                      name: '${kOrder.toUpperCase()}S',
                      textColor: kHintColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    space(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                            elevation: kElevation,
                            color: kDoneColor,
                            child: Column(
                              children: <Widget>[
                                TextWidget(
                                  name:  PageConstants.getWorkingForAllVendor.length == 0?'0':

                                  DateTime.now().day != PageConstants.getWorkingForAllVendor[0]['day']?'0':
                                  PageConstants.getWorkingForAllVendor[0]['dai'].toString()
                                  ,
                                  textColor: kHintColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                TextWidget(
                                  name:  kToday.toUpperCase(),
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),

                          Card(
                            elevation: kElevation,
                            color: kDoneColor,
                            child: Column(
                              children: <Widget>[
                                TextWidget(
                                  name:  PageConstants.getWorkingForAllVendor.length == 0?'0':
                                  Jiffy().week != PageConstants.getWorkingForAllVendor[0]['wky']?'0':
                                  PageConstants.getWorkingForAllVendor[0]['wkb'].toString(),



                                  textColor: kHintColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                TextWidget(
                                  name:  kWeekly.toUpperCase(),
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),


                          Card(
                            elevation: kElevation,
                            color: kDoneColor,
                            child: Column(
                              children: <Widget>[
                                TextWidget(
                                  name:  PageConstants.getWorkingForAllVendor.length == 0?'0':

                                  DateTime.now().month != PageConstants.getWorkingForAllVendor[0]['mth']?'0':
                                  PageConstants.getWorkingForAllVendor[0]['mtb'].toString(),



                                  textColor: kHintColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                TextWidget(
                                  name:  kMonthly.toUpperCase(),
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),

                          Card(
                            elevation: kElevation,
                            color: kDoneColor,
                            child: Column(
                              children: <Widget>[
                                TextWidget(
                                  name: PageConstants.getWorkingForAllVendor.length == 0?'0':

                                  DateTime.now().year != PageConstants.getWorkingForAllVendor[0]['yr']?'0':
                                  PageConstants.getWorkingForAllVendor[0]['yb'].toString(),


                                  textColor: kHintColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                TextWidget(
                                  name:  kYearly.toUpperCase(),
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    space(),
                  ],
                ),
              ),

              space(),
              space(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal2),
                child:   Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          name:  kStatus,
                          textColor: kHintColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          name:  PageConstants.getVendor[0]['tr'] == true?
                          'In Transit':'Office',
                          textColor: kWhiteColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    space(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          name:  kPhone,
                          textColor: kHintColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          name:  PageConstants.getVendor[0]['ph'] ,
                          textColor: kWhiteColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    space(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          name:  kEmail2,
                          textColor: kHintColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          name:  PageConstants.getVendor[0]['email'] ,
                          textColor: kWhiteColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    space(),

                    space(),
                    Divider(thickness: 0.1,color: kHintColor,),
                    space(),

                    GestureDetector(
                      onTap: (){
                        /*Navigator.push(context,
                PageTransition(
                    type: PageTransitionType
                        .scale,
                    alignment: Alignment
                        .bottomCenter,
                    child: BookingTransaction()));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            name: kUpcoming.toUpperCase(),
                            textColor: kWhiteColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.bold,
                          ),

                          SvgPicture.asset('assets/imagesFolder/back_right.svg',color: kWhiteColor,),
                        ],
                      ),
                    ),
                    space(),
                    Divider(thickness: 0.1,color: kHintColor,),
                    space(),

                    GestureDetector(
                      onTap: (){
                        /*Navigator.push(context,
                PageTransition(
                    type: PageTransitionType
                        .scale,
                    alignment: Alignment
                        .bottomCenter,
                    child: BookingTransaction()));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            name: '${kOrderHistory.toUpperCase()} (${PageConstants.getWorkingForAllVendor.length == 0?'0':PageConstants.getWorkingForAllVendor[0]['yb'].toString()})',
                            textColor: kWhiteColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.bold,
                          ),

                          SvgPicture.asset('assets/imagesFolder/back_right.svg',color: kWhiteColor,),
                        ],
                      ),
                    ),
                    space(),
                    Divider(thickness: 0.1,color: kHintColor,),
                    space(),
                  ],
                ),


              )

            ],
          ),
        ),
      ),
    );
  }
}
