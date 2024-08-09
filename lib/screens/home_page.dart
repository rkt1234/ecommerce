import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/screens/signin.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:ecommerce/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(
      widget.token,
    );
    print(widget.token);
    print(jwtDecoded);
    customerName = jwtDecoded['customerName'];
    customerId = jwtDecoded['sub'];
    customerAddress = jwtDecoded['address'];
    customerEmail = jwtDecoded['email'];
  }

  void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  bool isselected = false;
  String selectedCategory = "All";
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
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Cart"),
        ],
      ),
      body: Column(
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
                    future:
                        getCategory(), // Replace with your actual stream or future returning categories
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return  ListView.builder(
        itemCount: snapshot.data!.length,
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ChoiceChip(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              label: Text(snapshot.data![index]),
              selected: selectedCategory == snapshot.data![index],
              onSelected: (selected) {
                setState(() {
                  selectedCategory = snapshot.data![index];
                });
              },
            ),
          );
          },
);
                        // return ListView.builder(
                        //   itemCount: snapshot.data!.length,
                        //   itemBuilder: (context, index) {
                        //     return ListTile(
                        //       title: Text(snapshot.data![index]),
                        //       // You can add more widgets here to display additional info
                        //     );
                        //   },
                        // );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
                      // By default, show a loading spinner
                      return Center(child: CircularProgressIndicator());
                    },
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Products',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Container(
              // decoration: BoxDecoration(border: Border.all(color: Colors.black)),r
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 190,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      push(context, ProductPage(token: widget.token));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ProductTile(),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
