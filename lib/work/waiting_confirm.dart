import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/work/vendor_office.dart';

class WaitingConfirm extends StatefulWidget {
  @override
  _WaitingConfirmState createState() => _WaitingConfirmState();
}

class _WaitingConfirmState extends State<WaitingConfirm> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: WillPopScope(
      onWillPop: () => Future.value(false),
      child: Column(
        children: <Widget>[
          Container(

            child: Text('Wait let your customer confirm you'),
          ),

          RaisedButton(
            onPressed: (){
              Navigator.pushReplacement(context,
                  PageTransition(
                      type: PageTransitionType
                          .scale,
                      alignment: Alignment
                          .bottomCenter,
                      child: VendorOffice()));
            },
            child: Text('go back to office'),
          )
        ],
      ),
    )));
  }
}
