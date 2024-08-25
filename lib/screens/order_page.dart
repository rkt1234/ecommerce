import 'package:confetti/confetti.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:flutter/material.dart';
class OrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  OrderPage({
    Key? key,
    required this.cartItems,
    required this.total,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Place Order'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display cart items
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      // Extracting price and quantity
                      final double price = double.parse(
                          widget.cartItems[index]['price'].toString());
                      final int quantity = int.parse(
                          widget.cartItems[index]['quantity'].toString());

                      // Calculating total price for this item
                      final double totalPrice = price * quantity;

                      return ListTile(
                        title: Text(widget.cartItems[index]['title']),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text("Grand total: \$${widget.total.toStringAsFixed(2)}"),
                // Button to place the order
                ElevatedButton(
                  onPressed: (){
                    getToast(context, "Order placed", Icon(Icons.check,color: Colors.green,));
                    _confettiController.play();
                    pop(context);
                  },
                  child: Text('Place Order'),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.green, Colors.blue, Colors.orange, Colors.pink],
            // createParticlePath: drawStar,
          ),
        ],
      ),
    );
  }
}
