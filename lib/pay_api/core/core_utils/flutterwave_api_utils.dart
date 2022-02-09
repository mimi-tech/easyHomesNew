import 'dart:convert';
import 'dart:io';

import 'package:easy_homes/pay_api/core/flutterwave_error.dart';

import 'package:easy_homes/pay_api/models/responses/get_bank/get_bank_response.dart';
import 'package:easy_homes/pay_api/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;


/// Flutterwave Utility class
class FlutterwaveAPIUtils {

  /// This method fetches a list of Nigerian banks
  /// it returns an instance of GetBanksResponse or throws an error
  static Future<List<GetBanksResponse>> getBanks(
      final http.Client client) async {
    try {
      final response = await client.get(Uri.parse(FlutterwaveURLS.GET_BANKS_URL));//(FlutterwaveURLS.GET_BANKS_URL);
      if (response.statusCode == 200) {
        final List<dynamic> jsonDecoded = jsonDecode(response.body);
        final banks =
            jsonDecoded.map((json) => GetBanksResponse.fromJson(json)).toList();

        return banks;
      } else {
        throw (FlutterWaveError("Unable to fetch banks. Please contact support"));
      }
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
  }




}
