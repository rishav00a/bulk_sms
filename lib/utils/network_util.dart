import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

//  var token = "Something";

  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, String token) {
    print("util page " + url);
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);
      print(response.statusCode);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      try{
        return _decoder.convert(res);
      }
      catch(e){
        return res;
      }

    });
  }

  Future<dynamic> post(String url, token, {Map headers, body, encoding}) {
    return http
        .post(url,
        body: body,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token","content-type" : "application/json"},
        encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> put(String url, token, {Map headers, body, encoding}) {
    return http
        .put(url,
        body: body,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> postWithFile(String url, File file_u, token,
      {Map headers, encoding}) async {
    // var stream = new http.ByteStream(DelegatingStream.typed(file_u.openRead()));
    //   // get file length
    //   var length;
    //   file_u.length().then((onValue){
    //     length = onValue;
    //   });

    // var multipartFile = new http.MultipartFile('file', stream, length,
    //       filename: basename(file_u.path));
    // var uri = Uri.parse(url);
    // var request = new http.MultipartRequest("POST", uri);
    // request.files.add(multipartFile);

    //   // send
    //   var response = await request.send();
    //   print(response.statusCode);

    //   // listen for response
    //   response.stream.transform(utf8.decoder).listen((value) {
    //     print(value);
    //   });

    return http
        .put(url,
        body: file_u.readAsBytesSync(),
        headers: {HttpHeaders.authorizationHeader: "JWT $token", "authkey":"msg_91_auth_key"},
        encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> postFileWithBody(String url, File file_u, body, token,
      {Map headers, encoding}) async {
    return http
        .put(url,
        body:
        json.encode({"body": body, "file1": file_u.readAsBytesSync()}),
        headers: {HttpHeaders.authorizationHeader: "JWT $token"},
        encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }


}
