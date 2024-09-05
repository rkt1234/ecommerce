import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:ecommerce/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final token;
  const HomePage({super.key, this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late SharedPreferences pref;
  late Future<List<String>> _categoryFuture;
  String selectedCategory = "all"; // Initial category

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _categoryFuture = getCategory(); // Initialize category future
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.token);
    customerName = jwtDecoded['customerName'];
    customerId = jwtDecoded['sub'];
    customerAddress = jwtDecoded['address'];
    customerEmail = jwtDecoded['email'];
    print(widget.token);
  }

  void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> _getProducts() {
    return getProducts(selectedCategory);
  }

  void _onSelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Featured Products',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10.0),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 200),
            viewportFraction: 1,
          ),
          items: [
            Image.network(
              height: 200,
              "https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_UF1000,1000_QL80_.jpg",
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            Image.network(
              height: 200,
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqv578X-YrItIsYUTgP2GiuOufUAztUfI58w&s",
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: FutureBuilder<List<String>>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChoiceChip(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            label: Text(snapshot.data![index]),
                            selected: selectedCategory == snapshot.data![index],
                            onSelected: (selected) {
                              _onSelected(snapshot.data![index]);
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            'Products',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var filteredProducts = snapshot.data!
                      .where((product) =>
                          product['category'] == selectedCategory ||
                          selectedCategory == 'all')
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          push(
                            context,
                            ProductPage(
                              token: widget.token,
                              title: filteredProducts[index]['title'],
                              description: filteredProducts[index]
                                  ['description'],
                              category: filteredProducts[index]['category'],
                              productId: filteredProducts[index]['productid'],
                              price: filteredProducts[index]['price'],
                              imageUrl: filteredProducts[index]['imageurl'],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: ProductTile(
                            title: filteredProducts[index]['title'],
                            description: filteredProducts[index]['description'],
                            price: filteredProducts[index]['price'],
                            category: filteredProducts[index]['category'],
                            productId: filteredProducts[index]['productid'],
                            imageUrl: filteredProducts[index]['imageurl'],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}