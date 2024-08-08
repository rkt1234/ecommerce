import 'dart:convert';

import 'package:ecommerce/models/customer_model.dart';
import 'package:ecommerce/utils/api_urls.dart';
import 'package:http/http.dart' as http;

Future<dynamic> registerService (
    String email, String password, String address, String name) async {
  print("inside register");
  Map<String, String> body = CustomerModel(
          password: password,
          email: email,
          customerName: name,
          address: address)
      .toJsonRegister();
  Map<String, String> headers = {'Content-Type': 'application/json'};
  // Add other headers if needed
  print(body);

  dynamic response = await http.post(Uri.parse(registerUrl),
      body: jsonEncode(body), headers: headers);
  print(response.body);
  return response;
} 

Future<dynamic> loginService(String email, String password) async {
  print("api call started");
  Map<String, String> body =
      CustomerModel(password: password, email: email, customerName: '', address: '')
          .toJsonLogin();
  Map<String, String> headers = {'Content-Type': 'application/json'};
  // Add other headers if needed

  dynamic response = await http.post(Uri.parse(loginUrl),
      body: jsonEncode(body), headers: headers);
  return response;
} 
