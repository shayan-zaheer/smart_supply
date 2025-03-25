import 'package:flutter/material.dart';



class PaymentStatusPage extends StatelessWidget {
  final bool isPaymentSuccessful; // Track payment status

  // Constructor to receive the payment status
  PaymentStatusPage({required this.isPaymentSuccessful});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isPaymentSuccessful ? Colors.green[100] : Colors.red[100],
      appBar: AppBar(
        title: Text('Payment Status'),
        backgroundColor: isPaymentSuccessful ? Colors.green : Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isPaymentSuccessful
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: isPaymentSuccessful ? Colors.green : Colors.red,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                isPaymentSuccessful
                    ? 'Payment Successful'
                    : 'Payment Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPaymentSuccessful ? Colors.green[700] : Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // You can perform an action here (like going back or retrying)
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaymentSuccessful ? Colors.green : Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  isPaymentSuccessful ? 'Go Back' : 'Retry Payment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
