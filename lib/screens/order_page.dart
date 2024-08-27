import 'package:confetti/confetti.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final String token;

  const OrderPage({
    super.key,
    required this.cartItems,
    required this.total,
    required this.token,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late ConfettiController _confettiController;
  bool _isLoading = false;
  bool _isOrderPlaced = false;
  List<int> cartIds = [];
  List<Map<String, dynamic>> localCart = [];

  @override
  void initState() {
    super.initState();
    localCart = List<Map<String, dynamic>>.from(
        widget.cartItems); // Deep copy of cartItems
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    cartIds = extractCartIds(localCart);
  }

  List<int> extractCartIds(List<Map<String, dynamic>> cartItems) {
    List<int> cartIds = [];
    for (dynamic item in cartItems) {
      if (item['cartid'] != null) {
        if (item['cartid'] is int) {
          cartIds.add(item['cartid']);
        } else if (item['cartid'] is String) {
          cartIds.add(int.parse(item['cartid']));
        }
      }
    }
    return cartIds;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    // Using localCart which is independent of the provider's state
    String response = await placeOrder(widget.token, localCart, cartIds);

    setState(() {
      _isLoading = false;

      if (response == "Order placed and cart cleared successfully") {
        _isOrderPlaced = true;
        _confettiController.play();
        getToast(context, "Order placed successfully",
            const Icon(Icons.check, color: Colors.green));

        // Clear the cart in CartProvider after the order is placed successfully
        context.read<CartProvider>().clearCart();
      } else {
        getToast(context, "Could not place order",
            const Icon(Icons.error, color: Colors.red));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Place Order'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Assuming customerName and customerAddress are being passed correctly
                Text(
                  'Name: $customerName',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Address: $customerAddress',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: localCart.length,
                    itemBuilder: (context, index) {
                      final double price =
                          double.parse(localCart[index]['price'].toString());
                      final int quantity =
                          int.parse(localCart[index]['quantity'].toString());
                      final double totalPrice = price * quantity;

                      return ListTile(
                        title: Text(localCart[index]['title'] ?? 'No Title'),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text("Grand total: \$${widget.total.toStringAsFixed(2)}"),
                ElevatedButton(
                  onPressed: _isOrderPlaced ? null : _placeOrder,
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.pink
            ],
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }
}
