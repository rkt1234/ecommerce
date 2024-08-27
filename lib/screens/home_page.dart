import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/screens/profile_page.dart';
import 'package:ecommerce/screens/signin.dart';
import 'package:ecommerce/screens/cart_page.dart'; // Import the CartPage
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:ecommerce/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;
  late Future<List<Map<String, dynamic>>> _productsFuture;
  String selectedCategory = "all"; // Initial category
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    updateProductsFuture(); // Fetch products initially
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.token);
    customerName = jwtDecoded['customerName'];
    customerId = jwtDecoded['sub'];
    customerAddress = jwtDecoded['address'];
    customerEmail = jwtDecoded['email'];
    print(widget.token);
    _pages.addAll([
      buildHomeScreen(),

      // ProfilePage(), // Replace with your ProfilePage widget
      CartPage(token: widget.token), // CartPage widget
      ProfilePage(token: widget.token,)
    ]);
  }

  void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  void updateProductsFuture() {
    // Update _productsFuture whenever the selected category changes
    setState(() {
      _productsFuture =
          getProducts(selectedCategory); // Fetch products based on category
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeScreen() {
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
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvS7Bc0GHMNYqESMoWRv--SG95YQgpRSpicQ&s",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Image.network(
              height: 200,
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvS7Bc0GHMNYqESMoWRv--SG95YQgpRSpicQ&s",
              fit: BoxFit.cover,
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
                future: getCategory(),
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
                              setState(() {
                                selectedCategory = snapshot.data![index];
                                updateProductsFuture();
                              });
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
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          push(
                            context,
                            ProductPage(
                              token: widget.token,
                              title: snapshot.data![index]['title'],
                              description: snapshot.data![index]['description'],
                              category: snapshot.data![index]['category'],
                              productId: snapshot.data![index]['productid'],
                              price: snapshot.data![index]['price'],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: ProductTile(
                            title: snapshot.data![index]['title'],
                            description: snapshot.data![index]['description'],
                            price: snapshot.data![index]['price'],
                            category: snapshot.data![index]['category'],
                            productId: snapshot.data![index]['productid'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await pref.remove('jwt_token');
                pushReplacement(context, const SigninScreen());
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("Shopnow"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        
        ],
      ),
    );
  }
}
