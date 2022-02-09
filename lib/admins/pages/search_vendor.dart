import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/usersAddMinus.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/vendor_documents.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class VendorSearchStream extends StatefulWidget {
  @override
  _VendorSearchStreamState createState() => _VendorSearchStreamState();
}

class _VendorSearchStreamState extends State<VendorSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<dynamic> itemsData = <dynamic>[];
  // var tempSearchStore = [];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  var vendorData = <dynamic>[];

  var capitalizedValue;
  bool progressSecond = false;
  bool isAddAmount = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }




  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {

        itemsData = [];
      });
    }

    capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    try{
      FirebaseFirestore.instance.collectionGroup('companyVendors')
          .where('sk', isEqualTo: capitalizedValue)
          .limit(Variables.limit)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          itemsData.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              itemsData.add(document.data());
              queryResultSet.add(document);

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
      FirebaseFirestore.instance.collectionGroup('companyVendors')
          .where('sk', isEqualTo: capitalizedValue)
      .startAfterDocument(_lastDocument).limit(Variables.limit)

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
              queryResultSet.add(document);
              itemsData.add(document.data());

              moreData = false;
            });
          }
        }
      });
    }catch(e){
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          title: Text('Search for a vendor',
            style: GoogleFonts.rajdhani(
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: kWhiteColor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhiteColor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (dynamic val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by first name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    itemsData.length == 0? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidgetAlign(
                        name: kWhomToSee2,
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ):
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemsData.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  TextWidget(
                                    name: '${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                                    textColor: kLightBrown,
                                    textSize: kFontSize,
                                    textWeight: FontWeight.w500,
                                  ),
                                  TextWidget(
                                    name: itemsData[index]['email'],
                                    textColor: kTextColor,
                                    textSize: kFontSize,
                                    textWeight: FontWeight.w500,
                                  ),
                                  Divider(),
                                  Row(

                                    children: <Widget>[
                                      VendorPix(pix:itemsData[index]['pix'] ,pixColor: Colors.transparent,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
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


                                        ],
                                      ),


                                      Spacer(),

                                      AdminConstants.category == AdminConstants.partner!.toLowerCase()?Text(''):

                                      itemsData[index]['bl'] == true?Text(''):ElevatedButton(
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
                                  TextWidget(
                                    name: itemsData[index]['date'],
                                    textColor: kDarkRedColor,
                                    textSize: kFontSize14,
                                    textWeight: FontWeight.w500,
                                  ),
                                  space(),
                                  Divider(),
                                  Text("Home Address".toUpperCase(),
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
                                    name: '${itemsData[index]['str']}'.toUpperCase(),
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
                                        name: VariablesOne.numberFormat.format(itemsData[index]['wal']).toString(),
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
                                    IconButton(
                                      icon: Icon(Icons.view_agenda),
                                      onPressed: () {
                                        Navigator.of(context).push
                                          (MaterialPageRoute(
                                            builder: (context) => VendorDocument(doc:queryResultSet[index])));

                                      },
                                    ),


                                  ],):Text('')
                                ],
                              ),
                            ),
                          );
                        }),
                    prog == true || _loadMoreProgress == true
                        || queryResultSet.length < Variables.limit
                        ?Text(''):
                    moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                        onTap: (){loadMore();},
                        child: SvgPicture.asset('assets/imagesFolder/load_more.svg',)  )
                  ])
              )])
    ));
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
          //itemsData[index]['wal'] = itemsData[index]['wal']-Deposit.amount;

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
          //itemsData[index]['wal'] = itemsData[index]['wal'] + Deposit.amount;
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

