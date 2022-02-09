import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/transactions/date_sliver.dart';
import 'package:easy_homes/admins/transactions/transAppbar.dart';
import 'package:easy_homes/admins/transactions/trans_construct.dart';
import 'package:easy_homes/admins/transactions/trans_list_sliversappbar.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FromToTrans extends StatefulWidget {
  @override
  _FromToTransState createState() => _FromToTransState();
}

class _FromToTransState extends State<FromToTrans>with TickerProviderStateMixin{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // getPaymentList();
    //getpaymentListFlutterWave();

    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }
  String? filter;

  List<dynamic> listsEmail = <dynamic>[];
  List<dynamic> listsChannel = <dynamic>[];
  List<dynamic> listsAmount = <dynamic>[];
  List<dynamic> listsGateway = <dynamic>[];

  List<dynamic> listsStatus = <dynamic>[];
  List<dynamic> listsDate = <dynamic>[];
  List<dynamic> listsMobile = <dynamic>[];
  List<dynamic> listsName = <dynamic>[];


  bool progress = false;
  bool progressShow = false;
  var date = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

  Map? myMap;
  late Map<String,dynamic> jsonDecoded;

  Widget bodyList(int index){
    //DateTime currentPhoneDate = DateTime.now(); //DateTime

    /*for(int i= 0; i < listsDate.length; i++) {

    Timestamp myTimeStamp = listsDate[i]; //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

    var d = DateFormat('d MMM, yyyy').format(myDateTime);
    listsDateTime.add(d);
    print("current phone data is: $myDateTime");

  }
*/


    return  Column(
      children: [
        TransConstruction(
          email: listsEmail[index],
          channel: listsChannel[index],
          status: listsStatus[index],
          name: listsName[index],
          amount: listsAmount[index],
          gateWay: listsGateway[index],
          date: listsDate[index],//listsDateTime[index],
          mobile: listsMobile[index],

        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){getPaymentList();getpaymentListFlutterWave();},
        child: Icon(Icons.calendar_today),
      ),
        appBar:TransAppBar(title: 'Transaction Date',),

        body:CustomScrollView(slivers: <Widget>[
          SilverAppBarTransList(
            tutorialColor: kCartoonColor,
            eventsColor: kWhiteColor,
            expertColor: kCartoonColor,
            coursesColor: kCartoonColor,
            publishColor: kCartoonColor,
          ),

          SilverAppBarTransDate(),
          SliverList(
              delegate: SliverChildListDelegate([


                progress?Center(child: PlatformCircularProgressIndicator()):

                Column(
                  children: [
                    Visibility(
                      visible: progressShow?true:false,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listsEmail.length, itemBuilder: (context, int index) {


                        return filter == null || filter == "" ?bodyList(index):
                        '${listsEmail[index]}'.toLowerCase()
                            .contains(filter!.toLowerCase())

                            ?bodyList(index):Container();
                      }),
                    ),

                    progressShow?Text(''): Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidgetAlign(
                        name: 'Please select the date and time intervals you want to see',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),
                    ),


                  ],
                ),


              ]
              )
          )
        ]
        ))
    );
  }

  Future<void> getPaymentList() async {
    setState(() {
      progress = true;
      listsEmail.clear();
      listsStatus.clear();
      listsGateway.clear();
      listsChannel.clear();
      listsDate.clear();
      listsMobile.clear();
      listsName.clear();

    });

    http.Response res = await http.get('https://api.paystack.co/transaction?from=${TransactionDate.pickedDateTransFrom }&to=${TransactionDate.pickedDateTransTo}' as Uri,
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
    //headers:{"Authorization: Bearer"});
print(res.body);
    if (res.statusCode == 200) {

      jsonDecoded = jsonDecode(res.body);
      //print(jsonDecoded['data']['channel']);
      var videos = jsonDecoded['data'];

      for (var item in videos){ //iterate over the list
        myMap = item;
        setState(() {
          listsEmail.add(myMap!['customer']['email']);
          listsAmount.add(myMap!['amount']);
          listsStatus.add(myMap!['status']);
          listsGateway.add(myMap!['gateway_response']);
          listsChannel.add(myMap!['channel']);
          listsDate.add(myMap!['created_at']);
          listsMobile.add(myMap!['customer']['phone']);
          listsName.add(myMap!['customer']['first_name']);

        });


      }

      //get all transaction from flutterWave


    }else{
      setState(() {
        progress = false;
      });
      print('error occured');
    }}

  Future<void> getpaymentListFlutterWave() async {
    print('oooooooooo');
    http.Response res = await http.get('https://api.flutterwave.com/v3/transactions?from=${TransactionDate.pickedDateTransFrom}&to=${TransactionDate.pickedDateTransTo}' as Uri,
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'});


    print(res.body);
    if (res.statusCode == 200) {
      setState(() {
        progress = false;
        progressShow = true;
      });
      jsonDecoded = jsonDecode(res.body);

      //print(jsonDecoded['data']['channel']);
      var videos = jsonDecoded['data'];

      for (var item in videos){ //iterate over the list
        myMap = item;
        setState(() {
          listsEmail.add(myMap!['customer']['email']);
          listsAmount.add(myMap!['amount']);
          listsStatus.add(myMap!['status']);
          listsGateway.add(myMap!['processor_response']);
          listsChannel.add(myMap!['payment_type']);
          listsDate.add(myMap!['created_at']);
          listsMobile.add(myMap!['customer']['phone_number']);
          listsName.add(myMap!['customer']['name']);


        });

      }
    }else{
      setState(() {
        progress = false;
        //progressError = true;
      });
      print(res.statusCode);
      print(res);
      print('failed request');
    }
  }}
