import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UploadingProgress extends StatefulWidget {
  @override
  _UploadingProgressState createState() => _UploadingProgressState();
}

class _UploadingProgressState extends State<UploadingProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

            /// showing the progress bar
              if (VendorConstants.uploadTask != null)
                StreamBuilder<TaskSnapshot>(
                    stream: VendorConstants.uploadTask!.snapshotEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
                      Widget? subtitle;
                      Widget? prog;
                      TaskSnapshot? snapshot = asyncSnapshot.data;

                      TaskState? state = snapshot?.state;
                     // Widget progtext;
                      if (asyncSnapshot.hasData) {
                        final TaskSnapshot? event = asyncSnapshot.data;
                        //final StorageTaskSnapshot snapshot = event.snapshot;

                        double _progress = event!.bytesTransferred.toDouble() /
                            event.totalBytes.toDouble();

                        prog = CircularPercentIndicator(
                         // width: MediaQuery.of(context).size.width * 0.7,
                          //width: ScreenUtil().setWidth(160.0),
                          radius: 40.0,
                          lineWidth: 5.0,

                          //lineHeight: 8.0,
                          //animationDuration: 2000,
                          percent: _progress,

                          center: Text('${(_progress * 100).toStringAsFixed(2)} %',

                              style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(12,
                              ),
                          fontWeight: FontWeight.w700,
                        )
                          ),
                          progressColor: kProgressCompleted,
                          backgroundColor:kProgressBar ,

                        );

                        //progtext = Text('${(_progress * 100).toStringAsFixed(2)} %');

                      } else {
                        subtitle = state == TaskState.paused ?Text('paused',
                            style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(kFontSize,
                                  ),
                              fontWeight: FontWeight.w700,
                            )
                        ):Text('starting...',
                            style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(kFontSize,
                                  ),
                              fontWeight: FontWeight.w700,
                            )
                        );
                      }
                      return

                        state == TaskState.success?

                        // VendorConstants.uploadTask.isComplete && VendorConstants.uploadTask.isSuccessful ?
                      Container(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.check_circle,
                          color: kProgressCompleted,
                        ),
                      )

                          :  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Container(
                            child: subtitle,
                          ),
                          Container(
                            child: prog,
                          ),

                          Offstage(
                            offstage: state == TaskState.running,
                            child: GestureDetector(
                              child: Icon(Icons.pause),
                              onTap: () =>
                              TaskState.paused,
                            ),
                          ),

                          Offstage(
                            offstage: state == TaskState.paused,
                            child: GestureDetector(
                              child: Icon(Icons.file_upload),
                              onTap: () =>
                                  VendorConstants.uploadTask!.resume(),
                            ),
                          ),


                          SizedBox(
                            width: ScreenUtil().setWidth(30.0),
                          ),

                          Offstage(
                            offstage: state == TaskState.success,
                            child: PopupMenuButton(
                              elevation: 30.0,
                              child:Icon(
                                (Icons.cancel),

                              ),
                              itemBuilder: (context) => [
                                ///warning icon


                                PopupMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.0, left: 18.0, right: 18.0),
                                    child: Text(
                                      'Cancel',
                                        style: GoogleFonts.oxanium(
                                          fontSize: ScreenUtil().setSp(kFontSize,
                                              ),
                                          fontWeight: FontWeight.w700,
                                          color: kBlackColor
                                        )
                                    ),
                                  ),
                                ),

                                ///close btn
                                PopupMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Row(
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Close',
                                                style: GoogleFonts.oxanium(
                                                    fontSize: ScreenUtil().setSp(kFontSize,
                                                        ),
                                                    fontWeight: FontWeight.w700,
                                                    color: kBlackColor
                                                )
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                new BorderRadius.circular(4.0),
                                                side:
                                                BorderSide(color: kTurnOnBtn)),
                                          ),
                                          SizedBox(
                                            width: kBackspace,
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              VendorConstants.uploadTask!.cancel();
                                              setState(() {
                                                VendorConstants.uploadTask = null;

                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              kCuh,
                                                style: GoogleFonts.oxanium(
                                                    fontSize: ScreenUtil().setSp(kFontSize,
                                                        ),
                                                    fontWeight: FontWeight.w700,
                                                    color: kBlackColor
                                                )
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                new BorderRadius.circular(4.0),
                                                side:
                                                BorderSide(color: kTurnOnBtn)),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      );
                    }),

              ///cancel upload btn
              SizedBox(
                width: kBackspace,
              ),
            ],
          ),
        ),
       Container()
      ],
    );
  }
}
/*LinearProgressIndicator(

                            valueColor:
                                AlwaysStoppedAnimation<Color>(kSsprogresscompleted),
                            value: _progress,
                            backgroundColor: kSsprogressbar,
                          ),*/