import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



// class CreateAccountScreenRetailer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               SizedBox(height: 10),

//               // Title
//               Text(
//                 "Create Account",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Input Fields
//               _buildInputField("Enter Name","Name"),
//               _buildInputField("Enter Email Address","Email Address"),
//               _buildInputField("Enter Phone Number","Phone Number"),
//               _buildInputField("Enter Password","Password", obscureText: true),
//               _buildInputField("Enter Address","Address"),
              

//               SizedBox(height: 30),

//               // Continue Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Handle form submission
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:Color.fromARGB(255, 68, 10,228),// Light purple button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Text(
//                     "Continue",
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget to create a text input field
//   Widget _buildInputField(String hint,String mylabel, {bool obscureText = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           hintText: hint,
//           labelText: mylabel,
//           hintStyle: TextStyle(fontSize: 16, color: Colors.grey), // Hint text size
//           labelStyle: TextStyle(fontSize: 16),
//           filled: true,
//           fillColor: Colors.grey.shade200,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//       ),
//     );
//   }
// }


class CreateAccountScreenRetailer extends StatelessWidget {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),

              // Title
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Input Fields
              _buildInputField("Enter Name", "Name", controller: nameController),
              _buildInputField("Enter Email Address", "Email Address", controller: emailController),
              _buildInputField("Enter Phone Number", "Phone Number", controller: phoneController),
              _buildInputField("Enter Password", "Password", obscureText: true, controller: passwordController),
              _buildInputField("Enter Address", "Address", controller: addressController),

              SizedBox(height: 30),

              // Continue Button
              continueButton(context),
              SizedBox(height: 20),
              loginButton(context)
            ]
          ),
        ),
      ),
    );
  }

  SizedBox loginButton(BuildContext context) {
    return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                
                Navigator.pushNamed(context,'/login' ); // Call the form submission function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 68, 10, 228),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Already have account?Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            
          );
  }

  SizedBox continueButton(BuildContext context) {
    return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  
                  _submitForm(context); // Call the form submission function
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 68, 10, 228),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
  }

  // Widget to create a text input field
  Widget _buildInputField(String hint, String mylabel, {bool obscureText = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          labelText: mylabel,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          labelStyle: TextStyle(fontSize: 16),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // Function to handle form submission
  Future<void> _submitForm(BuildContext context) async {
  // Check if any of the fields are empty
  if (nameController.text.isEmpty ||
      emailController.text.isEmpty ||
      phoneController.text.isEmpty ||
      passwordController.text.isEmpty ||
      addressController.text.isEmpty) {
    
    // Show a Snackbar with an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All fields are required! Cannot create account.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red, // Red color for error
      ),
    );
    return; // Exit the function if any field is empty
  }
    // Collect data from text fields
    final Map<String, String> data = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'address': addressController.text,
    };

    // Send data to the backend
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/retailer_signup'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
    // Success
            print('Retailer signup successful');

            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          content: Text('Account successfully created!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally, navigate to another screen after success (e.g., login page)
      Navigator.pushNamed(context, '/login'); // Example: Navigate to login screen
        } else {
            // Error
            print('Retailer signup failed: ${response.body}');
            
        }
        } catch (e) {
            print('Error: $e');       
}
    }
  }

