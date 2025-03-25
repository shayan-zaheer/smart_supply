import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import json package for decoding response
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  OrderHistory({super.key});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<dynamic> orders = []; // Define orders list to store fetched data

  // Fetch orders from the API
  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve values from SharedPreferences
    int retailerId = prefs.getInt('retailer_id') ?? 0; // Default to 0 if no value is found

    print('***********Fetching Orders************************');
    dynamic id = retailerId; // Hardcoded RetailerId, replace with actual ID if necessary
    final response = await http.get(Uri.parse('http://localhost:5000/fetchorders?RetailerId=$id'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      setState(() {
        orders = json.decode(response.body); // Parse the response body to the orders list
        print(orders); // Log the fetched orders
      });
    } else {
      // If the server returns an error
      throw Exception('Failed to load orders');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Call fetchOrders on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Supply',
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 68, 10, 228),
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if orders is empty
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order ${index + 1}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 68, 10, 228),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.receipt, size: 30, color: Color.fromARGB(255, 68, 10, 228)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Retailer Email: ${order['RetailerEmail']}',
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Order ID: ${order['OrderId']}'), // Changed to OrderId to match API response
                        Text('Products: ${order['Products'].map((product) => product['ProductName']).join(', ')}'), 
                        // Loop through products and join them by commas
                        Text(
                          'Total Price: \$${order['TotalPrice']}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Order Date: ${order['OrderDateTime']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
