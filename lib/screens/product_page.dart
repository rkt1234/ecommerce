import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final dynamic price;
  final int productId;
  final String token;
  const ProductPage(
      {super.key,
      required this.token,
      required this.title,
      required this.description,
      required this.category,
      this.price,
      required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late SharedPreferences pref;
  final TextEditingController _reviewController = TextEditingController();
  late Future<List<Map<String, String>>> _futureReviews;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchReviews();
  }
    void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  void fetchReviews() {
    setState(() {
      _isFetching = true; // Start fetching, show progress indicator
    });

    _futureReviews = getReviews(widget.productId);

    _futureReviews.whenComplete(() {
      setState(() {
        _isFetching = false; // Done fetching, hide progress indicator
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: ${widget.category}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Cost: ${widget.price}",
                    style: const TextStyle(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async{
                        // Add to cart functionality
                        bool? ispresent=pref.getBool(widget.title);
                        print(ispresent);
                        if (ispresent == null) {
                          String message = await addToCart(
                              widget.token, widget.productId, widget.price, 1);

                          if (message == "Product added to cart successfully") {
                            await pref.setBool(widget.title,
                                true); // Await to ensure completion
                            print(message);

                            // Force a rebuild if necessary (optional)
                            if (mounted) {
                              setState(() {});
                            }

                            getToast(
                              context,
                              message,
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            );
                          } else {
                            getToast(
                              context,
                              message,
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          }
                        }

                        else {
                          pref.remove(widget.title);
                          getToast(context, "Already added in cart", const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ));
                        }
                      },
                      child: const Text("Add to Cart",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Reviews",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (_isFetching)
                    const Center(child: CircularProgressIndicator())
                  else
                    FutureBuilder<List<Map<String, String>>>(
                      future: _futureReviews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Show loading spinner while waiting
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Show error message if there's an error
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${snapshot.data![index]['customerName']} : "),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.data![index]['review']!,
                                          maxLines: null,
                                          softWrap: true,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No reviews available');
                        }
                      },
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      errorText: provider.reviewError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: "Write a review",
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        String? message = await provider.checkValidity(
                            widget.token,
                            _reviewController.text,
                            widget.productId);
                        if (message == "Review added successfully") {
                          setState(() {
                            _reviewController.clear();
                            _isFetching =
                                true; // Start fetching, show progress indicator
                          });

                          fetchReviews();

                          getToast(
                            context,
                            message!,
                            const Icon(Icons.check, color: Colors.green),
                          );
                        } else if (message != null) {
                          getToast(
                            context,
                            message,
                            const Icon(Icons.error, color: Colors.red),
                          );
                        }
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
      },
    );
  }
}
