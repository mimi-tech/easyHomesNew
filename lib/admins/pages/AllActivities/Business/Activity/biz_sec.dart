import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/biz_bottombar.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_admin_log.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/admin_log_tab_second.dart';

import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/admins/constructors/logs_construct.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';


class BizSec extends StatefulWidget {
  @override
  _BizSecState createState() => _BizSecState();
}

class _BizSecState extends State<BizSec> {
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }


  bool progress = false;
  bool _publishModal = false;

  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmins();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }



  Widget bodyList(index){
    return  Column(
      children: <Widget>[



        SectaryLogs(image: PageConstants.sectaries[index]['pix'],
            fn: PageConstants.sectaries[index]['fn'],
            ln: PageConstants.sectaries[index]['ln'],
            ph: PageConstants.sectaries[index]['ph'],
            biz: PageConstants.sectaries[index]['biz'],
            show: true,
            delete: (){
              deleteAdmin(index);
            },

            call: () async {

              var url =
                  "tel:${PageConstants.sectaries[index]['ph']}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }

            },
            online: PageConstants.sectaries[index]['ol'] == true?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: TextWidgetAlign(
                    name:  PageConstants.sectaries[index]['lg'] ,
                    textColor: kGreenColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset('assets/imagesFolder/green_dot.svg',)

              ],
            ):

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: TextWidgetAlign(
                    name:  PageConstants.sectaries[index]['lo'] ,
                    textColor: kRadioColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset('assets/imagesFolder/grey_dot.svg',)

              ],
            )
        ),


        Divider(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    Iterable<dynamic> online =  PageConstants.sectaries.where((element) => element['ol'] == true);
    Iterable<dynamic> offline =  PageConstants.sectaries.where((element) => element['ol'] == false);

    return SafeArea(
        child: Scaffold(
            backgroundColor: kWhiteColor,
            bottomNavigationBar: BizBottomBar(
              block: kWhiteColor,
              cancel: kWhiteColor,
              addVendor: kWhiteColor,
              rating: kWhiteColor,
            ),
            appBar:SearchMainAdminAppBar(title:  AdminConstants.bizName!.toUpperCase(),),
            body: ProgressHUDFunction(
                inAsyncCall: _publishModal,
                child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                          backgroundColor: kWhiteColor,
                          pinned: false,
                          automaticallyImplyLeading: false,
                          floating: true,
                          bottom: PreferredSize(
                              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverAppHeight2),
                              child: Text('')
                          ),

                        flexibleSpace: Column(
                          children: <Widget>[
                            space(),

                            BusinessActivityPage(
                              azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                              azColor:kDividerColor,activityColor:kDividerColor,logColor: kBlackColor,),
                            space(),


                            AdminLogTabSecond(

                              secName: 'All Sectaries',
                              online: online.length.toString(),
                              offline: offline.length.toString(),
                              title: 'All Sectaries - ${PageConstants.sectaries.length}'.toString(),),
                          ],
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([

                          PageConstants.sectaries.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                          PageConstants.sectaries.length == 0 && progress == true ?
                          ErrorTitle(errorTitle:'No Sectary yet') :

                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: PageConstants.sectaries.length,
                              itemBuilder: (context, int index) {
                                return filter == null || filter == "" ?bodyList(index):
                                '${ PageConstants.sectaries[index]['biz']}'.toLowerCase()
                                    .contains(filter!.toLowerCase())

                                    ?bodyList(index):Container();

                              }
                          )

                        ]),
                      ),
                    ]))));
  }

  Future<void> getAdmins() async {
    if(PageConstants.sectaries.isEmpty){
    PageConstants.sectaries.clear();

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg')
        .where('ouid',isEqualTo: Variables.userUid)
        .where('cat', isEqualTo: AdminConstants.admin)

        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {

          PageConstants.sectaries.add(document.data);
          // PageConstants.getCompanies.clear();


        });
      }
    }
  }}
  void deleteAdmin(int index) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kRemoveAdmin.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Column(children: <Widget>[


          ]),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                Navigator.of(context).pop();
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
              name:  kRemoveAdmin.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[


            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: (kRemoveAdminText),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${PageConstants.sectaries[0]['fn'].toString().toUpperCase()} ${PageConstants.sectaries[0]['ln'].toString().toUpperCase()}',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),


                      TextSpan(
                        text: (kRemoveAdminText2),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                      ),



                    ]),
              ),
            ),

            space(),


            YesNoBtn(no: (){Navigator.pop(context);},yes: (){removeAdmin(index);},)

          ],
        ));

  }

  Future<void> removeAdmin(int index) async {
    try{
      Navigator.pop(context);
      setState(() {
        _publishModal = true;
      });
      await FirebaseFirestore.instance.collection
('userReg').doc(PageConstants.sectaries[index]['ud'])
          .update({'cat': FieldValue.delete(),
        'ouid': FieldValue.delete(),
        'biz': FieldValue.delete(),
        'create': FieldValue.delete(),
        'pi': FieldValue.delete(),
      });

      await FirebaseFirestore.instance.collection
('userReg').doc(Variables.userUid)
          .update({'ano': AdminConstants.noAdminCreated - 1
      });

      setState(() {
        //remove vendor at index
        AdminConstants.noAdminCreated--;
        PageConstants.sectaries.remove(index);

        _publishModal = false;
      });

      getAdmins();

      Fluttertoast.showToast(
          msg: 'Sectary removed successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){
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
