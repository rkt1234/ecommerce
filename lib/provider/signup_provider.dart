import 'dart:convert';

import 'package:ecommerce/services/customer_api_service.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  String? nameError;
  String? emailError;
  String? passwordError;
  String? addressError;
  bool isLoading = false;
  String toastMessage = "";
  late Icon icon;
  dynamic response;
  late String jwt;
  Future<bool> checkValidity(email, password, address, name) async {
    print("inside");
    emailError = email == "" ? "Please enter an email" : null;
    passwordError = password == "" ? "Please enter a password" : null;
    addressError = address == "" ? "Please enter an address" : null;
    nameError = name == "" ? "Please enter a name" : null;
    notifyListeners();
    return userServiceCall(email, password, address, name);
  }

  Future<bool> userServiceCall(email, password, address, name) async {
    isLoading = true;
    late bool isNavigate;
    

    if (emailError == null &&
        passwordError == null &&
        addressError == null &&
        nameError == null) {
          response = await registerService(email, password, address, name);
      if (response.statusCode == 200) {
        print("Registration successful");
        jwt = jsonDecode(response.body)['access_token'];
        toastMessage = "Registration successful";
        isNavigate = true;
        icon = const Icon(Icons.check, color: Colors.green);
      } else {
        toastMessage = jsonDecode(response.body)['message'];
        isNavigate = false;
        icon = const Icon(Icons.error, color: Colors.red);
      }
    }
    isLoading = false;
    notifyListeners();
    return isNavigate;
  }
}
