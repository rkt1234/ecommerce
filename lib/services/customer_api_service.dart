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
