import 'dart:convert';

import 'package:ecommerce/services/customer_api_service.dart';
import 'package:flutter/material.dart';

class SigninProvider extends ChangeNotifier {
  String? emailError;
  String? passwordError;
  dynamic response;
  late Icon icon;
  String toastMessage = "";
  String jwt = "";
  bool isLoading = false;

  Future<bool> checkValidity(String email, String password) async {
    print("yaha pe");
    print(email);
    print(password);
    emailError = email == "" ? "Please enter an email" : null;
    passwordError = password == "" ? "Please enter a password" : null;
    notifyListeners();
    return userServiceCall(email, password);
  }

  Future<bool> userServiceCall(email, password) async {
    isLoading = true;
    late bool isNavigate;
    if (emailError == null && passwordError == null) {
      response = await loginService(email, password);

      if (response.statusCode == 200) {
        jwt = jsonDecode(response.body)['access_token'];
        toastMessage = "Login successful";
        isNavigate = true;
        icon = const Icon(Icons.check, color: Colors.green);
      } else {
        toastMessage = "Unable";
        isNavigate = false;
        icon = const Icon(Icons.error, color: Colors.red);
      }
    }
    isLoading = false;
    notifyListeners();
    return isNavigate;
  }
}
