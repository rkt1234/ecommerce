import 'package:ecommerce/services/product_api_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String,dynamic>> cart=[];
  var res;
  Future<void> getCartItems(String token) async{
    final res=await fetchCart(token);
    if(res=="Failed to load cart") {
    } else {
      cart=res;
    }
  }

   void removeFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    cart[index]['quantity'] = newQuantity;
    notifyListeners();
  }

}