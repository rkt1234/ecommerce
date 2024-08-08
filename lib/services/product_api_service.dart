import 'dart:convert';

import 'package:ecommerce/utils/api_urls.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getCategory() async {
  final response = await http.get(Uri.parse(fetchCategoriesUrl));

  if (response.statusCode == 200) {
    // Decode the response body and ensure it is treated as a List<dynamic>
    List<dynamic> data = jsonDecode(response.body);

    // Convert List<dynamic> to List<String>
    List<String> categories = data.map((category) => category.toString()).toList();
    
    return categories;
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<Map<String, String>>> getReviews() async {
  final body = jsonEncode({'productId': 1});
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

