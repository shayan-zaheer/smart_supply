import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting the date
import 'package:crypto/crypto.dart'; // Import the crypto package for HMAC and sha256
import 'dart:convert';
import 'package:http/http.dart' as http; // Import the http package
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  int? retailerId;
  String? retailerName;
  String? retailerEmail;

  // Simulate the payment process
  var responcePrice;
  bool isLoading = false;
  void processPayment(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    print("process payment function is called");
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(Duration(days: 1)));
    String tre = "T"+dateandtime;
    String pp_Amount="100000";
    String pp_BillReference="billRef";
    String pp_Description="order payment";
    String pp_Language="EN";
    String pp_MerchantID="MC150308";
    String pp_Password="b21301ftxb";

    String pp_ReturnURL="www.example.com";
    String pp_ver = "1.1";
    String pp_TxnCurrency= "PKR";
    String pp_TxnDateTime=dateandtime.toString();
    String pp_TxnExpiryDateTime=dexpiredate.toString();
    String pp_TxnRefNo=tre.toString();
    String pp_TxnType="MWALLET";
    String ppmpf_1="4456733833993";
    String IntegeritySalt = "97u3t478y3";
    String and = '&';
    String superdata=
        IntegeritySalt+and+
            pp_Amount+and+
            pp_BillReference +and+
            pp_Description +and+
            pp_Language +and+
            pp_MerchantID +and+
            pp_Password +and+
            pp_ReturnURL +and+
            pp_TxnCurrency+and+
            pp_TxnDateTime +and+
            pp_TxnExpiryDateTime +and+
            pp_TxnRefNo+and+
            pp_TxnType+and+
            pp_ver+and+
            ppmpf_1
    ;



    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    var url = Uri.parse('https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction');

    print("before post");
    var response = await http.post(url, body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime":dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1":"4456733833993"
    });
    

    print("response=>");
    print(response.body);
    var res = await response.body;
    var body = jsonDecode(res);
    responcePrice = body['pp_Amount'];
    Fluttertoast.showToast(msg: "payment successfully $responcePrice");
    setState(() {
      isLoading = false;
    });


    final List<dynamic> CartItems = arguments?['cartItems'] ?? [];
    final double totalAmount = arguments?['total'] ?? 0.0;
    

    
    for (var item in CartItems) {
      print(item.productID);
    }
    print(totalAmount);


  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve values from SharedPreferences
  retailerId = prefs.getInt('retailer_id') ?? 0; // Default to 0 if no value is found
  retailerName = prefs.getString('retailer_name') ?? 'No Name'; // Default to 'No Name'
  retailerEmail = prefs.getString('retailer_email') ?? 'No Email'; // Default to 'No Email'

  // Print the retrieved values
  //print('Retailer ID: $retailerId');
  //print('Retailer Name: $retailerName');
  //print('Retailer Email: $retailerEmail');

    // Prepare the data for the POST request
    final Map<String, dynamic> orderData = {
      
      'RetailerId': retailerId, 
      'TotalPrice': totalAmount,
      'Products': CartItems
          .map((item) => {
                'ProductId': item.productID, // Assuming your cartItems have productId
              })
          .toList(),
    };
    print(orderData);
    // Make the POST request
    try {
      print("try is calld");
      final response = await http.post( //added await here
        Uri.parse('http://localhost:5000/placeorder'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        print("if is called");
        // Payment and order placement successful
        final responseData = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Payment of \$${totalAmount.toStringAsFixed(2)} was successful! OrderId: ${responseData['message'].split(': ').last}'),
          ),
        );
      } else {
        print("else is called");
        // Payment or order placement failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed. ${response.body}')),
        );
      }
    } catch (e) {
      print("catch is called");
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    }

    Navigator.pop(context); // Go back to the previous page after payment
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the totalAmount from the ModalRoute
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double totalAmount = arguments?['total'] ?? 0.0; // Correct retrieval

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Color.fromARGB(255, 68, 10, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => processPayment(context),
              child: Text('Pay Now (\$${totalAmount.toStringAsFixed(2)})'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 68, 10, 228),
              ),
            ),
          ],
        ),
      ),
    );
  }
}