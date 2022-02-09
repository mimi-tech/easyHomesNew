import 'dart:convert';

import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Services{
  static sendMail({required email, required message, required subject})async{
   try {
     String urlCheck = VariablesOne.emailEndpoint;
     Map<String, String> headersCheck = {
       "Content-type": "application/json",
       "authorization": "12345" //"${dotenv.env['SECRETE']}"
     };
     var bodyCheck = json.encode({
       'email': email,
       'message': message,
       'subject': subject,
     });
// make POST request
     Response responseCheck = await post(
         Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);
     if (responseCheck.statusCode == 200) {
       VariablesOne.notifyFlutterToast(title: "Email sent successfully");
     } else {
       VariablesOne.notifyFlutterToastError(title: kError);
       return;
     }
   }catch(e){

   }
    }


    //for sending sms
  static sendSms({required phoneNumber, required message})async{
   try {
     String urlCheck = VariablesOne.emailEndpoint;
     Map<String, String> headersCheck = {
       "Content-type": "application/json",
       "authorization": "12345" //"${dotenv.env['SECRETE']}"
     };
     var bodyCheck = json.encode({
       'phoneNumber': phoneNumber,
       'message': message,
     });
// make POST request
     Response responseCheck = await post(
         Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);
     if (responseCheck.statusCode == 200) {
       VariablesOne.notifyFlutterToast(title: "Sms sent successfully");
     } else {
       VariablesOne.notifyFlutterToastError(title: kError);
       return;
     }
   }catch(e){

   }
  }
  }

