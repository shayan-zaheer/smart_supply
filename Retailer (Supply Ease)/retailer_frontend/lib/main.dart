
import 'package:flutter/material.dart';
import 'package:retailer_frontend/SignIn.dart';
import 'package:retailer_frontend/checkout.dart';
import 'package:retailer_frontend/login_retailer.dart';
import 'package:retailer_frontend/orderHistory.dart';
import 'package:retailer_frontend/payment.dart';
import 'package:retailer_frontend/paymentStatus.dart';
import 'package:retailer_frontend/productss.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Supply',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Starting route
      routes: {
        '/': (context) => CreateAccountScreenRetailer(), // Home Page
        '/viewProducts': (context) => ProductScreen(), // View Products Page
        '/viewHistory': (context) => OrderHistory(), // View History Page
        '/login':(context) => LoginPageRetailer(), // Sign In Screen (for example)
        '/homePage':(context) => MyHomePage(), // Sign In Screen (for example)
        '/cart': (context) => CartPage(), // Cart Page (for example)
        '/payment' :(context)=>PaymentPage(),
        '/paymentstatus' :(context)=>PaymentStatusPage(isPaymentSuccessful: false),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String retailerName = '';
  String retailerEmail = '';

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      retailerName = prefs.getString('retailer_name') ?? 'No Name'; // Default to 'No Name' if not found
      retailerEmail = prefs.getString('retailer_email') ?? 'No Email'; // Default to 'No Email' if not found
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();  // Load the data from SharedPreferences when the widget is initialized
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
        backgroundColor:  Color.fromARGB(255, 68, 10, 228),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for main content
            Text(
              'Welcome to Smart Supply!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:Color.fromARGB(255, 68, 10, 228) ,
                
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    //backgroundImage: AssetImage('assets/avatar_placeholder.png'), // Placeholder for profile pic
                  ),
                  SizedBox(height: 10),
                  Text(
                    retailerName,
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    retailerEmail,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.smart_display),
              title: Text('View Products'),
              onTap: () {
                // Navigate to View Products page
                Navigator.pushNamed(context, '/viewProducts');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('View History'),
              onTap: () {
                // Navigate to View History page
                Navigator.pushNamed(context, '/viewHistory');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout action
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You have logged out!'),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}






