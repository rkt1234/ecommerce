import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/widgets/product_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isselected = false;
  List<String> cat = ["All", "Clothes", "Mobile", "Laptop"];
  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
      child: ListView.builder(
        itemCount: cat.length,
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ChoiceChip(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              label: Text(cat[index]),
              selected: selectedCategory == cat[index],
              onSelected: (selected) {
                setState(() {
                  selectedCategory = cat[index];
                });
              },
            ),
          );
        },
      ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                            'Products',
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
              ),
          const SizedBox(height: 10,),
               Flexible(
                 child: Container(
                  // decoration: BoxDecoration(border: Border.all(color: Colors.black)),r
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                   child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 190,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: const ProductTile(),
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
