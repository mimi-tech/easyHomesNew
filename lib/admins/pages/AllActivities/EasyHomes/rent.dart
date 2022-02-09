import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/all_rent.dart';
import 'package:easy_homes/admins/constructors/cancel_construct.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/rent_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/removed_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/verify_biz_owner.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/reg/constants/btn.dart';


import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';



class AllRentUsers extends StatefulWidget {
  @override
  _AllRentUsersState createState() => _AllRentUsersState();
}

class _AllRentUsersState extends State<AllRentUsers> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];

  var vendorData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;
  bool _itemLength = false;
  var itemsIndex = <int>[];
  bool showFirstContainer = true;
  List<dynamic> rr = <dynamic>[];
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }
  String? filter;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });

  }


  Widget bodyList(int index){
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: <Widget>[
            Row(

              children: <Widget>[
                VendorPix(pix:itemsData[index]['pix'] ,pixColor: Colors.transparent,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      name: itemsData[index]['fn'],
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),

                    TextWidget(
                      name: itemsData[index]['ln'],
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),



                    GestureDetector(
                      onTap:() async {
                        var url = "tel:${itemsData[index]['ph']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },

                      child: TextWidget(
                        name: itemsData[index]['ph'],
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                   /* TextWidget(
                      name: DateFormat('EE d MMM, yyyy').format(DateTime.parse(itemsData[index]['ts'])),
                      textColor: kDarkRedColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),*/
                  ],
                ),


                Spacer(),


                Container(
                  key: UniqueKey(),

                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape:BoxShape.circle,
                      color: kDoneColor
                  ),
                  child: IconButton(

                      onPressed:(){
                        getOrders(index);
                      },
                      icon: Icon(Icons.view_agenda_rounded,color: kWhiteColor,)
                  ),
                ),

              ],
            ),

            space(),






      ]
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    //PageConstants.allVendorCount.clear();
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: PageAddVendor(
              block: kWhiteColor,
              cancel: kWhiteColor,
              rating: kWhiteColor,
              addVendor: kWhiteColor,
              users: kYellow,
            ),

            appBar:CancelAppBar(

              title: 'Cylinder Rent'.toUpperCase(),),

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                getAll();
              },
              child: Icon(Icons.explore,color: kWhiteColor,),
            ),
            body: CustomScrollView(
                slivers: <Widget>[
                  SilverAppBarUsers(
                    block: kBlackColor,
                    editPin: kYellow,
                    remove: kBlackColor,
                    suspend: kBlackColor,

                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      space(),
                      itemsData.length == 0 && progress == false
                          ? Center(child: PlatformCircularProgressIndicator())
                          : itemsData.length == 0 && progress == true
                          ? ErrorTitle(errorTitle: 'No one have rented any cylinder'.toString(),)
                          : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _documents.length,
                          itemBuilder: (context, int index) {
                            return filter == null || filter == "" ?bodyList(index):
                            '${itemsData[index]['fn']}'.toLowerCase()
                                .contains(filter!.toLowerCase())

                                ?bodyList(index):Container();

                          }),

                    ],
                    ),
                  )



                ])
        ));


  }

  Future<void> getComments() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("rent").orderBy('ts',descending: false)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());


        });
        rr.addAll(data['re']);


        /*for (int i = 0; i < rr.length; i++) {
          var diffDt = DateTime.parse(rr[i]['dt']).difference(DateTime.now()); // 249:59:59.999000
          print(diffDt);
        }*/

      }


    }
  }




    void getOrders(int index) {

      //show details of the cylinders rent
      List<dynamic> rt = List.from(itemsData[index]['re']);

      print(rt);
      Platform.isIOS ?
      //show ios bottom modal sheet
      showCupertinoModalPopup(

          context: context, builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            RentConstruct(items:itemsData,re:rt,index:index)
          ],
        );
      })

          : showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => RentConstruct(items:itemsData, re:rt,index:index)
      );


  }

  void getAll() {

    //show details of the cylinders rent
    Platform.isIOS ?
    //show ios bottom modal sheet
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          AllRentConstruct(re:rr)
        ],
      );
    })

        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => AllRentConstruct(re:rr)
    );



  }


}
