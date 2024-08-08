import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _reviews = [
    "Great product!",
    "Really enjoyed it!",
    "Could be better."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Page"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://w0.peakpx.com/wallpaper/908/670/HD-wallpaper-dhoni-sports-uniform-cricket-ms-dhoni-mahendra-singh-dhoni-thumbnail.jpg",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Product Title",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Product Description: This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                "Category: Electronics",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                "Cost: \$99.99",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    // primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Add to cart functionality
                  },
                  child:
                      const Text("Add to Cart", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Reviews",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 3, // Blur radius
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Naman Sharma : "),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Text(
                            "Product Description: This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.This is an amazing product that you will love! It has several features and benefits that make it a must-have item for anyone.",
                            maxLines: null,
                            softWrap: true,
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Write a review",
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    // primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                  
                  },
                  child: const Text("Submit Review",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
