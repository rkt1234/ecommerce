import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/screens/order_page.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final String token;
  const CartPage({super.key, required this.token});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _futureCart;

  @override
  void initState() {
    super.initState();
    _fetchCartDetails();
  }

  void _fetchCartDetails() {
    _futureCart = fetchCart(widget.token);
    _futureCart.then((cartItems) {
      if (cartItems.isNotEmpty) {
        // Updating the provider state outside of build method
        final cartProvider = context.read<CartProvider>();
        cartProvider.updateShowTotal(true);
        cartProvider.cart = cartItems;
        cartProvider.calculateTotal(); // Calculate total here
      } else {
        context.read<CartProvider>().updateShowTotal(false);
      }
    }).catchError((error) {
      // Handle error if needed
      print('Error fetching cart details: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Column(
          children: [
            Flexible(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureCart,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Show loading spinner while waiting
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show error message if there's an error
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: cartProvider.cart.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: double.infinity,
                                    width: 160,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://w0.peakpx.com/wallpaper/908/670/HD-wallpaper-dhoni-sports-uniform-cricket-ms-dhoni-mahendra-singh-dhoni-thumbnail.jpg",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartProvider.cart[index]['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cartProvider.cart[index]['quantity']
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              String message =
                                                  await deleteCartItem(
                                                cartProvider.cart[index]
                                                    ['cartid'],
                                                widget.token,
                                              );
                                              _fetchCartDetails();
                                              if (message ==
                                                  "Item deleted successfully") {
                                                getToast(
                                                  context,
                                                  message,
                                                  const Icon(Icons.check,
                                                      color: Colors.green),
                                                );
                                                  cartProvider.calculateTotal();
                                              } else {
                                                getToast(
                                                  context,
                                                  message,
                                                  const Icon(Icons.error,
                                                      color: Colors.red),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red, size: 15),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (cartProvider.cart[index]
                                                      ['quantity'] >=
                                                  1) {
                                                cartProvider.updateQuantity(
                                                  index,
                                                  cartProvider.cart[index]
                                                          ['quantity'] +
                                                      1,
                                                );
                                                await updateCart(
                                                  cartProvider.cart[index]
                                                      ['cartid'],
                                                  cartProvider.cart[index]
                                                      ['quantity'],
                                                  widget.token,
                                                );
                                                  cartProvider.calculateTotal();
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.exposure_plus_1,
                                                color: Colors.green,
                                                size: 15),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (cartProvider.cart[index]
                                                      ['quantity'] >
                                                  1) {
                                                cartProvider.updateQuantity(
                                                  index,
                                                  cartProvider.cart[index]
                                                          ['quantity'] -
                                                      1,
                                                );
                                                await updateCart(
                                                  cartProvider.cart[index]
                                                      ['cartid'],
                                                  cartProvider.cart[index]
                                                      ['quantity'],
                                                  widget.token,
                                                );
                                                cartProvider.calculateTotal();
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.exposure_minus_1,
                                                color: Colors.red,
                                                size: 15),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        (double.parse(cartProvider.cart[index]
                                                        ['price']
                                                    .toString()) *
                                                double.parse(cartProvider
                                                    .cart[index]['quantity']
                                                    .toString()))
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Cart is empty'));
                  }
                },
              ),
            ),
            cartProvider.showTotal
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            push(context,  OrderPage(cartItems: cartProvider.cart,total: cartProvider.res,));

                          },
                          child: const Text('Proceed to buy cart items'),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
