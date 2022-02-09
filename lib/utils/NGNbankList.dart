import 'dart:convert';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
class NGBankList extends StatefulWidget {
  @override
  _NGBankListState createState() => _NGBankListState();
}

class _NGBankListState extends State<NGBankList> {
String errorText = '';
bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(VariablesOne.banksLists.length == 0){
      getMyBankAgain();
    }
  }


  Future<void> getMyBankAgain() async {
    try {
      setState(() {
        progress = true;
      });
      String url = "https://api.paystack.co/bank?country=nigeria";

      http.Response res = await http.get(Uri.parse(url),
          headers: {
            VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'
          });
       print(res);
       print('good going');
      if (res.statusCode == 200) {
        print('running');
        final Map<String, dynamic> jsonDecoded = json.decode(res.body);
        var videos = jsonDecoded['data'];
        //iterate over the list

        for (var item in videos) {
          Map myMap = item;
          setState(() {
            VariablesOne.banksLists.add(myMap['name']);
            VariablesOne.banksListsCode.add(myMap['code']);

            progress = false;
          });
        }
      } else {
        setState(() {
          errorText = kErrorText;
          progress = false;
        });
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        child: progress?Center(child: CupertinoProgressHud()):Column(
        children: <Widget>[

        StickyHeader(
        header:  AdminHeader(title: 'List of Banks'.toUpperCase(),),

          content: ListView.builder(
            physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: VariablesOne.banksLists.length,
        itemBuilder: (context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    getBank(index);
                  },

                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.ac_unit,color: kLightBrown,),
                          SizedBox(width: 30,),
                          TextWidgetAlign(name: VariablesOne.banksLists[index],
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,),
                        ],
                      ),
                    ),
                  ),
                ),
              );
        })),
          TextWidgetAlign(
            name: errorText,
            textColor: kRedColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w600,
          ),
                ]
        ),
      ),
    ))

    );

  }

  void getBank(int index) {
    setState(() {
      VendorConstants.bankName = VariablesOne.banksLists[index];
      VendorConstants.bankNameCode = VariablesOne.banksListsCode[index];
      VariablesOne.name.text = VendorConstants.bankName!;
    });
    Navigator.pop(context);
  }


}
