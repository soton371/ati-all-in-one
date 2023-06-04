import 'dart:convert';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void sendLocation(String pEMPLOYEID, String pMLATITUDE, String pMLONGITDE,
    String pLOCAREANM, String pSAUSERSID) async {
      debugPrint('call sendLocation');
  String pEMGISTIME = DateFormat('h:mm a').format(DateTime.now());
  String pGISDTADTM = DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now());

  Uri url = Uri.parse(MyUrls.sendLocation);
  Map payload = {
    "p_CLOCTYPID": "0",
    "p_DEVBATPCT": "0",
    "p_EMGISTIME": pEMGISTIME,
    "p_EMPLOYEID": pEMPLOYEID,
    "p_GISDTADTM": pGISDTADTM,
    "p_GISDTA_DT": "0",
    "p_GISDTA_FG": "0",
    "p_GPSLOCION": "0",
    "p_LOCAREANM": pLOCAREANM,
    "p_MLATITUDE": pMLATITUDE,
    "p_MLONGITDE": pMLONGITDE,
    "p_MOVEMNTID": "",
    "p_SAUSERSID": pSAUSERSID,
    "p_SESSIONID": "0"
  };

  // debugPrint('payload: $payload');
  try {
    var response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: json.encode(payload));
    debugPrint('sendLocation response body: ${response.body}');
  } catch (e) {
    debugPrint('sendLocation e: $e');
  }
}
