import 'dart:convert';
import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/utils/api_urls.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  final body = jsonEncode(
      ReviewModel(review, productId, customerId, customerName).toJson());

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

Future<String> addToCart(
    String token, int productId, dynamic total, int quantity) async {
  // Assuming customerId is already defined somewhere in your code
  // Replace with actual customerId

  // API endpoint to add to cart

  // Create the body for the POST request
  Map<String, dynamic> body = {
    "productId": productId, // Replace with actual productId
    "quantity": quantity,
    "customerId": customerId,
    "total": total,
  };
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    // Make POST request
    var response = await http.post(Uri.parse(addToCartUrl),
        body: jsonEncode(body), headers: headers);

    // Check if request was successful (status code 200)
    if (response.statusCode == 200) {
      // Return success message or handle response data as needed
      return 'Product added to cart successfully';
    } else if (response.statusCode == 409) {
      return 'Product already added in cart';
    } else {
      // Handle other status codes if needed
      return 'Failed to add product to cart: ${response.statusCode}';
    }
  } catch (e) {
    // Handle any exceptions that occur during the request
    return 'Error adding product to cart: $e';
  }
}

Future<List<Map<String, dynamic>>> fetchCart(String token) async {
  final headers = {
    'Authorization': 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(fetchCartUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);

      // Ensure the decoded response is a list of maps
      return decodedResponse
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      // Handle non-200 responses here, maybe log the error or notify the user
      print('Failed to fetch cart items: ${response.statusCode}');
      throw Exception('Failed to load cart');
    }
  } catch (e) {
    // Handle any exceptions such as network issues or JSON decoding errors
    print('An error occurred: $e');
    throw Exception('Failed to load cart');
  }
}

Future<void> updateCart(int cartId, int quantity, String token) async {
  print("isme aa chuka hai bhai");
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  Map<String, int> body = {'cartId': cartId, 'quantity': quantity};

  try {
    final response = await http.put(Uri.parse(updateCartUrl),
        headers: headers, body: jsonEncode(body));
    print(response.body);
  } catch (e) {}
}

Future<String> deleteCartItem(int cartId, String token) async {
  //
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  Map<String, int> body = {'cartId': cartId};
  try {
    final response = await http.delete(Uri.parse(deleteCartUrl),
        headers: headers, body: jsonEncode(body));
    return jsonDecode(response.body)['message'];
  } catch (e) {
    return "Could not delete item";
  }
}

Future<String> placeOrder(
    String token, List<Map<String, dynamic>> items, List<int> cartIds) async {
  print("tell me ");
  print(items);
  print(cartIds);
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  DateTime now = DateTime.now();
  String createdTime = DateFormat('M/d/yyyy h:mm a').format(now);
  // Add the `date` key to each map in `items`
  // Example: "2024-08-26 15:30:00"
for (int i = 0; i < items.length; i++) {
    items[i]['date'] = createdTime;
  }

// Now each map in `items` will have a `date` key with the current date-time value
  print(items);

  final body = {
    "items": items,
    "customerId": customerId,
    "date": createdTime,
    "deliveryAddress": customerAddress,
    "cartIds": cartIds
  };

  try {
    final response = await http.post(Uri.parse(placeOrderUrl),
        headers: headers, body: jsonEncode(body));
    print(jsonDecode(response.body)['message']);
    return jsonDecode(response.body)['message'];
  } catch (e) {
    print(e);
    return "Could not place order";
  }
}

Future<List<Map<String, dynamic>>> fetchOrder(String token) async {
  final headers = {
    'Authorization': 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(fetchOrderUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);
  print(decodedResponse);
      // Ensure the decoded response is a list of maps
      return decodedResponse
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      // Handle non-200 responses here, maybe log the error or notify the user
      print('Failed to fetch orders: ${response.statusCode}');
      throw Exception('Failed to fetch orders');
    }
  } catch (e) {
    // Handle any exceptions such as network issues or JSON decoding errors
    print('An error occurred: $e');
    throw Exception('Failed to fetch orders');
  }
}
