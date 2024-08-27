import 'package:ecommerce/services/product_api_service.dart';
import 'package:ecommerce/utils/configs.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

 final String token;
   ProfilePage(
      {super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $customerName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $customerEmail',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
             Text(
              'Address: $customerAddress',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order history',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchOrder(token),
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
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.network(
                                snapshot.data![index]['imageUrl'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image, size: 60),
                              ),
                              title: const Text("title",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: '),
                                  Text('Total Price:'),
                                  Text('Order Date: '),
                                ],
                              ),
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
          ],
        ),
      ),
    );
  }
}


