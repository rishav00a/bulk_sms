import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://api.yaresa.tech/";
  static final LOGIN_URL = BASE_URL + "login";
  static final GET_AUTH_TOKEN_URL = BASE_URL + "get_auth_token";
  static final MSG91_FLOW = "http://api.msg91.com/api/v5/flows";
  static final MSG91_HTTP = "https://api.msg91.com/api/sendhttp.php";

  static final PWA_URL = "https://api.msg91.com/api/v5/flow/";



  Future<dynamic> login(String user, String password, String fcm_token) async {
    print("res");

    return _netUtil.post(LOGIN_URL, "", body: {
      "username": user,
      "password": password,
      "fcm_token": fcm_token,
      "authentication_type": "dashboard"
    }).then((dynamic res) async {
      print(res);

      return res;
    }).catchError((onError) {
      print(onError);
      throw new Exception("Error while fetching data");
    });
  }


  Future<dynamic> sendbulkSMSo(String message) async {
    print("res");

    return _netUtil.post(MSG91_FLOW, "", body: {
      "authkey": "309462Aq7u3FeNtJ5e109a48P1",
      "smsType": "2",
      "sender_id": "PJCOMM",
      "receiver": "##contact##",
      "message":message,
      "flow_name":DateTime.now().millisecondsSinceEpoch.toString()
    }).then((dynamic res) async {
      print(res);

      return res;
    }).catchError((onError) {
      print(onError);
      throw new Exception("Error while fetching data");
    });
  }


  Future<dynamic> sendbulkSMSM(List<dynamic> receip , String recep_mobiles, String message) async {
    print("res");

    return _netUtil.post(PWA_URL+"?", "", body: {
      "authkey": "309462Aq7u3FeNtJ5e109a48P1",
      "flow_id": "5f571c23374b19527e6c98d4",
      "sender": "PJCOMM",
      "unicode": "1",
      "route":"1",
      "recipients":json.encode(receip),
      "message":message,
      // "mobiles":recep_mobiles
    }).then((dynamic res) async {
      print(res);

      return res;
    }).catchError((onError) {
      print(onError);
      throw new Exception("Error while fetching data");
    });
  }


  Future<dynamic> sendbulkSMS(List<dynamic> receip , String recep_mobiles, String message) async {
    print("res");
    return _netUtil.get(MSG91_HTTP+"?authkey=309462Aq7u3FeNtJ5e109a48P1&unicode=1&route=4&country=91&sender=HAXOTK&mobiles=$recep_mobiles&message=$message", "",).then((dynamic res) async {
      print(res);
      return res;
    }).catchError((onError) {
      print(onError);
      throw new Exception("Error while fetching data");
    });
  }
}
