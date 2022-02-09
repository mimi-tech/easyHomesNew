import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/cancel_construct.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/usersAddMinus.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/removed_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/verify_biz_owner.dart';
import 'package:easy_homes/admins/pages/search_users.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/reg/constants/btn.dart';


import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/money_format.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';



class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
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
bool progressSecond = false;
  bool isAddAmount = false;

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
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),

                    TextWidget(
                      name: itemsData[index]['ln'],
                      textColor: kTextColor,
                      textSize: kFontSize14,
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
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                    TextWidget(
                      name: itemsData[index]['date'],
                      textColor: kDarkRedColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),

                    AdminConstants.category == AdminConstants.owner!.toLowerCase()
                        ?Row(children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                        getAmountToMinus(index);
                        },
                      ),

                      MoneyFormatColors(
                        color: kSeaGreen,
                        title: TextWidget(
                          name: VariablesOne.numberFormat.format(itemsData[index]['wal']).toString(),
                          textColor: kSeaGreen,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),
                      ),

                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          getAmountToAdd(index);

                        },
                      ),
                    ],):Text('')

                  ],
                ),


                Spacer(),

                AdminConstants.category == AdminConstants.owner!.toLowerCase()
                 ?

                itemsData[index]['bl'] == true?Text(''):RaisedButton(
                  onPressed: (){

                     verifyBlock(index);
                  },
                  color: kLightBrown,
                  child: TextWidget(
                    name: 'Block',
                    textColor: kWhiteColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ):Text('')
              ],
            ),

            space()



          ],
        ),
      ),
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

              title: 'All users'.toUpperCase(),),
            body: CustomScrollView(
              slivers: <Widget>[
                SilverAppBarUsers(
              block: kYellow,
              editPin: kBlackColor,
              remove: kBlackColor,
              suspend: kBlackColor,

            ),
            SliverAppBar(
              pinned: true,
              backgroundColor: kWhiteColor,
              title: GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: UsersSearchStream()));

                },
                child: Row(
                  children: [
                    IconButton(color:kStatusColor,icon: Icon(Icons.search), onPressed: (){}),
                    Text(kWhomToSee,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.adventPro(fontSize: ScreenUtil().setSp(kFontSize14, ),
                        color:kStatusColor,
                        fontWeight: FontWeight.w500,
                      )

                      ),
                   /* TextWidgetAlign(
                      name: kWhomToSee,
                      textColor: kStatusColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),*/
                  ],
                ),
              ),
            ),


            SliverList(
              delegate: SliverChildListDelegate([
                  space(),
                  itemsData.length == 0 && progress == false
                      ? Center(child: PlatformCircularProgressIndicator())
                      : itemsData.length == 0 && progress == true
                      ? ErrorTitle(errorTitle: kNoCancelOrder.toString(),)
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
                  progress == true ||
                      progress == true ||
                      _loadMoreProgress == true ||
                      _documents.length < Variables.limit
                      ? Text('')
                      : moreData == true
                      ? PlatformCircularProgressIndicator()
                      : GestureDetector(
                      onTap: () {
                        loadMore();
                      },
                      child: SvgPicture.asset(
                        'assets/imagesFolder/load_more.svg',
                      ))
                ],
              ),
            )



            ])
        ));


  }

  Future<void> getComments() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("userReg")
        .orderBy('date', descending: true)

        .limit(Variables.limit)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());
        });
      }
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("userReg")
        .orderBy('date', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;
        });
      }
    }
  }

  void verifyBlock(int index) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Block User',
          contentText: 'Are you sure you want to block this user ${itemsData[index]['fn']} ${itemsData[index]['ln']}',
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },

          actions: [
            NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRadioColor,title: 'No',),

            NewBtn(nextFunction: (){block(index);}, bgColor: kDoneColor,title: 'Yes',)

          ],
        );


      },
      animationType: DialogTransitionType.slideFromRightFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  void block(int index) {

   try{
     FirebaseFirestore.instance.collection
('userReg').doc(itemsData[index]['ud']).set({
     'bl':true
     },SetOptions(merge: true));

     setState(() {
       _documents.removeAt(index);
       itemsData.removeAt(index);
     });
     Navigator.pop(context);
     Fluttertoast.showToast(
         msg: 'Blocked successfully',
         toastLength: Toast.LENGTH_LONG,
         backgroundColor: kBlackColor,
         textColor: kGreenColor);
   }catch(e){
   VariablesOne.notifyFlutterToastError(title: kError);
   }
  }

  void minusWallet(int index) {
    //check if entered amount is bigger than the the present wallet
    if((Deposit.amount == null) || (Deposit.amount == 0)){
      VariablesOne.notifyErrorBot(title:kAllUsersText1 );

    }else if(Deposit.amount !> itemsData[index]['wal']){
      VariablesOne.notifyErrorBot(title: kAllUsersText2);
    }else{
    setState(() {
      progressSecond = true;
    });
    try{
    //remove the money from the customer wallet account
    FirebaseFirestore.instance
        .collection('userReg').doc(itemsData[index]['ud']).get()
        .then((resultEarnings) {

     var walletEarning = resultEarnings.data()!['wal'] - Deposit.amount;

      resultEarnings.reference.set({
        'wal':walletEarning,
      },SetOptions(merge: true));

    });
    setState(() {
itemsData[index]['wal'] = itemsData[index]['wal']-Deposit.amount;

    });
    getUserHistory(index);



    }catch(e){
      setState(() {
        progressSecond = false;
      });
      VariablesOne.notifyErrorBot(title: kError);

    }

    }}

  void getAmountToMinus(int index) {
    showModalBottomSheet(
         isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => UsersAddMinusWalletAmount(minusAdd:(){minusWallet(index);},
          walletText: kAllUsersText4,
          title: '$kAllUsersText5 (${itemsData[index]['fn']})',)
    );

  }

  void getAmountToAdd(int index) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => UsersAddMinusWalletAmount(minusAdd:(){addWallet(index);},
          walletText: kAllUsersTextAdd4,
          title: '$kAllUsersTextAdd1 (${itemsData[index]['fn']})',)
    );

  }

  void addWallet(int index) {
    //check if entered amount is bigger than the the present wallet
    if((Deposit.amount == null) || (Deposit.amount == 0)){
      VariablesOne.notifyErrorBot(title: kAllUsersTextAdd1);

    }else if(Deposit.amount !> itemsData[index]['wal']){
      VariablesOne.notifyErrorBot(title: kAllUsersTextAdd2);
    }else{
      setState(() {
        progressSecond = true;
      });
      try{
        //add the money to the customer wallet account
        FirebaseFirestore.instance
            .collection('userReg').doc(itemsData[index]['ud']).get()
            .then((resultEarnings) {

          var walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

        });

        setState(() {
          itemsData[index]['wal'] = itemsData[index]['wal'] + Deposit.amount;
          isAddAmount = true;
        });
        getUserHistory(index);



      }catch(e){
        setState(() {
          progressSecond = false;
        });
        VariablesOne.notifyErrorBot(title: kError);

      }}
  }

  void getUserHistory(int index) {

    try{
      DocumentReference documentReference =  FirebaseFirestore.instance.collection
        ('History').doc();
      documentReference.set({
        'id':documentReference.id,
        'ud':itemsData[index]['ud'],
        'amt':Deposit.amount,
        'ts':DateTime.now().toString(),
        'dp': isAddAmount?kTxnFailureAdd:kTxnFailure,
      });

      Navigator.pop(context);
      VariablesOne.notifyFlutterToast(title: kAllUsersText3);
      setState(() {
        progressSecond = false;
      });
    }catch(e){
      setState(() {
        progressSecond = false;
      });
      VariablesOne.notifyErrorBot(title: kError);


    }

  }


}
