import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String,dynamic>> cart=[];
  var res;
  
  //  void removeFromCart(int index) {
  //   cart.removeAt(index);
  //   notifyListeners();
  // }

  void updateQuantity(int index, int newQuantity) {
    cart[index]['quantity'] = newQuantity;
    notifyListeners();
  }

}