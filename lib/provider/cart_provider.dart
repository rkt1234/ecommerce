import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> cart = [];
  bool showTotal = false;
  double res = 0.0;

  void updateQuantity(int index, int newQuantity) {
    cart[index]['quantity'] = newQuantity;
    notifyListeners();
  }

  void calculateTotal() {
    res = 0.0; // Reset total before calculation
    for (int i = 0; i < cart.length; i++) {
      // Parse 'price' and 'quantity' as double before performing the operation
      double price = double.tryParse(cart[i]['price'].toString()) ?? 0.0;
      int quantity = int.tryParse(cart[i]['quantity'].toString()) ?? 0;

      res = res + (price * quantity);
    }
    notifyListeners();
  }

  void updateShowTotal(bool val) {
    showTotal = val;
    notifyListeners();
  }
    void clearCart() {
    cart.clear();
    showTotal = false;
    res = 0.0;
    notifyListeners();
  }
}

