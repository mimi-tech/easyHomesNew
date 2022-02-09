import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/usersAddMinus.dart';
import 'package:easy_homes/funds/constants.dart';


import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/reg/constants/btn.dart';


import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/show_prize.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';



class AllBusiness extends StatefulWidget {
  @override
  _AllBusinessState createState() => _AllBusinessState();
}

class _AllBusinessState extends State<AllBusiness> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }



  var vendorData = <dynamic>[];
  bool moreData = false;
  bool progress = false;

  bool progressSecond = false;
  bool isAddAmount = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }
  String? filter;



  static  List<dynamic> workingDocuments = <dynamic> [];
  List<DocumentSnapshot> _documents = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  StreamSubscription? stream;

  bool _loadMoreProgress = false;
  var _lastDocument;
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


  Widget bodyList(int index){
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              name:"${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}",
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name:  workingDocuments[index]['email'],
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),
Divider(),
            Row(

              children: <Widget>[
                VendorPix(pix: workingDocuments[index]['pix'] ,pixColor: Colors.transparent,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[



                    GestureDetector(
                      onTap:() async {
                        var url = "tel:${ workingDocuments[index]['ph']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },

                      child: TextWidget(
                        name:  workingDocuments[index]['ph'],
                        textColor: kDoneColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                    TextWidget(
                      name:  workingDocuments[index]['date'],
                      textColor: kDarkRedColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),



                  ],
                ),


                Spacer(),

                 AdminConstants.category == AdminConstants.partner!.toLowerCase()?Text(''):

                 workingDocuments[index]['bl'] == true?Text(''):ElevatedButton(
                  onPressed: (){

                    verifyBlock(index);
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
              name: '${workingDocuments[index]['biz']}'.toUpperCase(),
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
              name: '${workingDocuments[index]['add']}'.toUpperCase(),
              textColor: kTextColor,
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
                  name: VariablesOne.numberFormat.format(workingDocuments[index]['wal']).toString(),
                  textColor: kSeaGreen,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
              ),

              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  getAmountToAdd(index);

                },
              ),
Spacer(),
      ShowPrizeTwo(title:kGasP2,prize:workingDocuments[index]['gas'],click: (){})

        ],):Text('')
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

              title: 'All Businesses'.toUpperCase(),),
            body: CustomScrollView(
                slivers: <Widget>[
                  SilverAppBarUsers(
                    block: kBlackColor,
                    editPin: kBlackColor,
                    remove: kBlackColor,
                    suspend: kYellow,

                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      space(),
                       workingDocuments.length == 0 && progress == false
                          ? Center(child: PlatformCircularProgressIndicator())
                          :  workingDocuments.length == 0 && progress == true
                          ? ErrorTitle(errorTitle: 'There is no registered business'.toString(),)
                          : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:  workingDocuments.length,
                          itemBuilder: (context, int index) {
                            return filter == null || filter == "" ?bodyList(index):
                            '${ workingDocuments[index]['biz']}'.toLowerCase()
                                .contains(filter!.toLowerCase())

                                ?bodyList(index):Container();

                          }),

                      prog == true || _loadMoreProgress == true
                          || workingDocuments.length < 1
                          ?Text(''):
                      moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                          onTap: (){loadMore();},
                          child: SvgPicture.asset('assets/imagesFolder/load_more.svg',)  )


                    ],
                    ),
                  )



                ])
        ));


  }

  void getOnline() {
    try{
      stream = FirebaseFirestore.instance.collection('AllBusiness')
          .where('appr', isEqualTo: true)
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
          .where('appr', isEqualTo: true)

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

  void verifyBlock(int index) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Block User',
          contentText: 'Are you sure you want to block this user ${ workingDocuments[index]['fn']} ${ workingDocuments[index]['ln']}',
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
('userReg').doc( workingDocuments[index]['ud']).set({
        'bl':true
      },SetOptions(merge: true));

      setState(() {
  workingDocuments.removeAt(index);
         workingDocuments.removeAt(index);
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

    }else if(Deposit.amount!> workingDocuments[index]['wal']){
      VariablesOne.notifyErrorBot(title: kAllUsersText2);
    }else{
      setState(() {
        progressSecond = true;
      });
      try{
        //remove the money from the customer wallet account
        FirebaseFirestore.instance
            .collection('userReg').doc(workingDocuments[index]['ud']).get()
            .then((resultEarnings) {

          var walletEarning = resultEarnings.data()!['wal'] - Deposit.amount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

        });

        //remove the money from the business wallet
        FirebaseFirestore.instance
            .collection('AllBusiness').doc(workingDocuments[index]['id']).get()
            .then((resultEarnings) {

          var walletEarning = resultEarnings.data()!['wal'] - Deposit.amount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

        });
        setState(() {
          workingDocuments[index]['wal'] = workingDocuments[index]['wal']-Deposit.amount;

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
          title: '$kAllUsersText5 (${workingDocuments[index]['fn']})',)
    );

  }

  void getAmountToAdd(int index) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => UsersAddMinusWalletAmount(minusAdd:(){addWallet(index);},
          walletText: kAllUsersTextAdd4,
          title: '$kAllUsersTextAdd1 (${workingDocuments[index]['fn']})',)
    );

  }

  void addWallet(int index) {
    //check if entered amount is bigger than the the present wallet
    if((Deposit.amount == null) || (Deposit.amount == 0)){
      VariablesOne.notifyErrorBot(title: kAllUsersTextAdd1);

    }else if(Deposit.amount!> workingDocuments[index]['wal']){
      VariablesOne.notifyErrorBot(title: kAllUsersTextAdd2);
    }else{
      setState(() {
        progressSecond = true;
      });
      try{
        //add the money to the customer wallet account
        FirebaseFirestore.instance
            .collection('userReg').doc(workingDocuments[index]['ud']).get()
            .then((resultEarnings) {

          var walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

        });

        //add the money to the business wallet
        FirebaseFirestore.instance
            .collection('AllBusiness').doc(workingDocuments[index]['id']).get()
            .then((resultEarnings) {

          var walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

        });
        setState(() {
          workingDocuments[index]['wal'] = workingDocuments[index]['wal'] + Deposit.amount;
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
        'ud':workingDocuments[index]['ud'],
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
