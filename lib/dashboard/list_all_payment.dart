import 'dart:convert';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/transactions/transAppbar.dart';
import 'package:easy_homes/admins/transactions/trans_construct.dart';
import 'package:easy_homes/admins/transactions/trans_list_sliversappbar.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/dash_appbar.dart';
import 'package:easy_homes/utils/dash_silver_appbar.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListOfAllPayment extends StatefulWidget {
  @override
  _ListOfAllPaymentState createState() => _ListOfAllPaymentState();
}

class _ListOfAllPaymentState extends State<ListOfAllPayment>with TickerProviderStateMixin{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPaymentList();
    getpaymentListFlutterWave();

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
  bool progressError = false;

  Map? myMap;
  late Map<String,dynamic> jsonDecoded;
  var date = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  Widget bodyList(int index){
    return  Column(
      children: [
        TransConstruction(
          email: listsEmail[index],
          channel: listsChannel[index],
          status: listsStatus[index],
          name: listsName[index],
          amount: listsAmount[index],
          gateWay: listsGateway[index],
          date: listsDate[index],
          mobile: listsMobile[index],

        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
        //appBar: DashAppBar(title: 'All payment status'.toUpperCase(),),
        body: CustomScrollView(slivers: <Widget>[
          SilverAppBarDashBoard(
            tutorialColor: kBlackColor,
            eventsColor: kDoneColor,
            expertColor: kBlackColor,
            coursesColor: kBlackColor,
            publishColor: kBlackColor,
          ),

          SliverList(
              delegate: SliverChildListDelegate([


                progress?Center(child: PlatformCircularProgressIndicator()):
                listsEmail.length == 0?ErrorTitle(errorTitle: 'Nothing was found'): Column(
                  children: [
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listsEmail.length, itemBuilder: (context, int index) {
                      return filter == null || filter == "" ?bodyList(index):
                      '${listsEmail[index]}'.toLowerCase()
                          .contains(filter!.toLowerCase())

                          ?bodyList(index):Container();
                    })
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

    http.Response res = await http.get('https://api.paystack.co/transaction?customer=${Variables.currentUser[0]['ctid']}' as Uri,
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
    //headers:{"Authorization: Bearer"});

    if (res.statusCode == 200) {

      jsonDecoded = jsonDecode(res.body);
      print(jsonDecoded);
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

    }}

  Future<void> getpaymentListFlutterWave() async {
    http.Response res = await http.get('https://api.flutterwave.com/v3/transactions?customer_email=${Variables.currentUser[0]['email']}' as Uri,
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'});
    //headers:{"Authorization: Bearer"});

    if (res.statusCode == 200) {
      setState(() {
        progress = false;
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

    }
  }}
