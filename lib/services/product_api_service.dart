import 'dart:convert';

import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/utils/api_urls.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getCategory() async {
  final response = await http.get(Uri.parse(fetchCategoriesUrl));

  if (response.statusCode == 200) {
    // Decode the response body and ensure it is treated as a List<dynamic>
    List<dynamic> data = jsonDecode(response.body);

    // Convert List<dynamic> to List<String>
    List<String> categories =
        data.map((category) => category.toString()).toList();

    return categories;
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<Map<String, String>>> getReviews(int productId) async {
  final body = jsonEncode({'productId': productId});
  final response = await http.post(
    Uri.parse(fetchReviewsUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    // Decode the JSON response and convert it to a List<Map<String, String>>
    List<dynamic> data = jsonDecode(response.body);
    print(data);
    List<Map<String, String>> reviews = data.map((review) {
      return Map<String, String>.from(review);
    }).toList();

    return reviews;
  } else {
    // Handle the error scenario
    throw Exception('Failed to load reviews');
  }
}

Future<List<Map<String, dynamic>>> getProducts(String selectedCategory) async {
  final url = fetchProductsUrl + selectedCategory;
  print("hello");
print(url);
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      List<dynamic> productsJson = jsonDecode(response.body);
      print(productsJson);
      // Convert each JSON object to a Map<String, String>
      List<Map<String, dynamic>> products = productsJson.map((json) {
        return Map<String, dynamic>.from(json);
      }).toList();

      return products;
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load products');
    }
  } catch (e) {
    // Catch any exceptions thrown during the http.get call.
    throw Exception('Failed to connect to the server');
  }
}

Future<String> addReviews(String token, String review, int productId) async {
  // Convert the ReviewModel to JSON
  final body = jsonEncode(ReviewModel(review, productId, customerId, customerName).toJson());

  // Define the headers for the request
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    // Send the POST request
    final response =
        await http.post(Uri.parse(addReviewUrl), body: body, headers: headers);

    // Check the response status code
    if (response.statusCode == 200) {
      // If successful, return a success message
      return 'Review added successfully';
    } else {
      // If an error occurs, return an error message with the status code
      return 'Failed to add review';
    }
  } catch (e) {
    print(e);
    // Handle any exceptions that might occur (e.g., network issues)
    return 'Failed to add review';
  }
}

