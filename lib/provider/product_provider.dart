import 'package:ecommerce/services/product_api_service.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  String? reviewError;
  
  Future<String?> checkValidity(String token, String review, int productId) async{
    reviewError = review == "" ? "Please enter a review" : null;
    notifyListeners();
    if(reviewError==null) {
      return productService( token, review,  productId);
    }
    return null;
  }

  Future<String> productService(
      String token, String review, int productId) async{
        print(review);
    String message = await addReviews(token, review,productId);
    return message;
  }
}