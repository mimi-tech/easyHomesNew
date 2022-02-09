import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/verify_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/searchbar.dart';
import 'package:easy_homes/utils/show_prize.dart';
import 'package:easy_homes/work/constructors/change_prize.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class BizScreen extends StatefulWidget {

  @override
  _BizScreenState createState() => _BizScreenState();
}

class _BizScreenState extends State<BizScreen> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  static  List<int> getCount = <int>[];
  bool progress = false;
  StreamSubscription? stream;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  static  List<dynamic> workingDocuments = <dynamic> [];
  List<DocumentSnapshot> _documents = <DocumentSnapshot> [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream!.cancel();
  }


  Widget bodyList(int index){
    return GestureDetector(
      onTap: (){
        getCompanyDocId(index);
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kCardRadius),
            topRight: Radius.circular(kCardRadius),
          ),),
        color: kWhiteColor,
        elevation: kCardElevation,
        child: Column(
          children: <Widget>[


            Row(
              children: <Widget>[
                SizedBox(width:imageRightShift.w),
                ImageScreen(image: workingDocuments[index]['pix'],),
                SizedBox(width:imageRightShift.w),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    TextWidget(
                      name: workingDocuments[index]['biz'].toString().toUpperCase(),
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),

                    workingDocuments[index]['add'] == null?Text(''): Container(

                      child: ConstrainedBox(

                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(250),
                          minHeight: ScreenUtil()
                              .setHeight(kConstrainedHeight),
                        ),
                        child: ReadMoreText(workingDocuments[index]['add'],

                            trimLines: 1,
                            colorClickableText:kRedColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' ...',
                            trimExpandedText: ' \n show less...',
                            style: GoogleFonts.oxanium(
                                textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(kFontSize14, ),
                                  color: kTextColor,
                                  fontWeight:FontWeight.bold,
                                )
                            )
                        ),
                      ),
                    ),


                    space(),
                    GestureDetector(
                      onTap: () async {
                        var url =
                            "tel:${workingDocuments[index]['ph']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: TextWidget(
                        name: workingDocuments[index]['ph'],
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),

              ],
            ),



            space(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowPrizeTwo(title:kGasP2,prize:workingDocuments[index]['gas'],click: (){
                  //do this while its a business
              if(AdminConstants.category == AdminConstants.business.toLowerCase()){

                  Variables.currentUser[0]['ca'] = workingDocuments[index]['id'];
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ChangeGasPrice()
                  );
                }},),
                workingDocuments[index]['apr'] == true? Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kLightBrown)

                      ),

                      onPressed:(){
                        verifyBlockBiz(index);},
                      child:TextWidget(
                        name:getCount.contains(index)?'...': 'Block',
                        textColor: kWhiteColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      )),
                ):Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(getCount.contains(index)?kLightBrown:kDoneColor)

                        ),

                        onPressed:(){verifyUnblockBiz(index);},
                        child:TextWidget(
                          name:getCount.contains(index)?'Block': 'Unblock',
                          textColor: kWhiteColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ))),
              ],
            )

          ],
        ),
      ),
    );
}
  String? filter;
  bool prog = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnline();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Container(

        height: MediaQuery.of(context).size.height * kModalHeight,
        child: workingDocuments.length == 0?

        NoWorkError(title: 'No Business have registered',)
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[

              StickyHeader(
                header:SearchBar(title: 'All Business',),


                content: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: workingDocuments.length,
                        itemBuilder: (context, int index) {
                          return filter == null || filter == "" ?bodyList(index):
                          '${workingDocuments[index]['biz']}'.toLowerCase()
                              .contains(filter!.toLowerCase())

                              ?bodyList(index):Container();
                        }
                    ),

                    prog == true || _loadMoreProgress == true
                        || workingDocuments.length < 1
                        ?Text(''):
                    moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                        onTap: (){loadMore();},
                        child: SvgPicture.asset('assets/imagesFolder/load_more.svg',)  )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
  void getCompanyDocId( int index) {

    setState(() {
      PageConstants.companyUD = workingDocuments[index]['id'];
      PageConstants.companyName = workingDocuments[index]['biz'];
    });


      Navigator.pop(context);

    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyDailyAnalysis()));



  }


  void getOnline() {
    try{
      stream = FirebaseFirestore.instance.collection('AllBusiness')
          .orderBy('date')
          .limit(VariablesOne.limit)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });


    }catch(e){
      VariablesOne.notifyFlutterToastError(title: kError);
    }

  }

  Future<void> loadMore() async {
    try {
      stream = FirebaseFirestore.instance.collection('AllBusiness')
          .orderBy('date')
          .startAfterDocument(_lastDocument).limit(VariablesOne.limit)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length == 0) {
          setState(() {
            _loadMoreProgress = true;
          });
        } else {
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;

            setState(() {
              moreData = true;
              _documents.add(document);
              workingDocuments.add(document.data());

              moreData = false;
            });
          }
        }
      });
    } catch (e) {
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }


  void verifyBlockBiz(int index) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kRemoveBiz.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content:  BizVerifyConstruct(text1:kRemoveAdminText,
            text2: '${PageConstants.sectaries[0]['fn'].toString().toUpperCase()} ${PageConstants.sectaries[0]['ln'].toString().toUpperCase()}',
            text3: kRemoveAdminText3,),

          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Yes'),
              onPressed: () {
                removeBiz(index);
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
              name:  kRemoveBiz.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[

            BizVerifyConstruct(text1:kRemoveAdminText,
                text2: '${workingDocuments[index]['bz'].toString().toUpperCase()} ${workingDocuments[index]['biz'].toString().toUpperCase()}',
                text3: kRemoveAdminText4,),

            space(),


            YesNoBtn(no: (){Navigator.pop(context);},yes: (){removeBiz(index);},)

          ],
        ));


  }


  void removeBiz(int index) {
Navigator.pop(context);

    try{
      FirebaseFirestore.instance.collection('AllBusiness').doc(workingDocuments[index]['id']).update({
        'apr':false
      });

      setState(() {
        workingDocuments.removeAt(index);
      });


      Fluttertoast.showToast(
          msg: 'Business blocked successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){

    VariablesOne.notifyFlutterToastError(title: kError);
    }
  }
  void verifyUnblockBiz(int index) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kUnblockBiz.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content:  BizVerifyConstruct(text1:kRemoveAdminText22,
            text2: '${workingDocuments[index]['bz'].toString().toUpperCase()} ${workingDocuments[index]['biz'].toString().toUpperCase()}',
            text3: kRemoveAdminText5,),

          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Yes'),
              onPressed: () {
                removeBiz(index);
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
              name:  kUnblockBiz.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[

            BizVerifyConstruct(text1:kRemoveAdminText22,
              text2: '${workingDocuments[index]['bz'].toString().toUpperCase()} ${workingDocuments[index]['biz'].toString().toUpperCase()}',
              text3: kRemoveAdminText5,),

            space(),


            YesNoBtn(no: (){Navigator.pop(context);},yes: (){unblock(index);},)

          ],
        ));

  }

  void unblock(int index) {

    Navigator.pop(context);
    setState(() {
      getCount.add(index);

    });
    try{
      FirebaseFirestore.instance.collection('AllBusiness').doc(workingDocuments[index]['id']).update({
        'apr':true
      });




      Fluttertoast.showToast(
          msg: 'Business Unblocked successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){
      setState(() {
        getCount.remove(index);
      });
    VariablesOne.notifyFlutterToastError(title: kError);
    }
  }

}
