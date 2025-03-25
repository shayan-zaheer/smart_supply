import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


// class _LoginPageState extends State<LoginPageRetailer> {
//   String name ="";
//   bool changedButton = false;
//   final _formkey = GlobalKey<FormState>();

// moveToHome(BuildContext context)async{
//    if(_formkey.currentState!.validate()){ 
//       setState(() {
//       changedButton = true;


//       });
//       await Future.delayed(Duration(seconds: 1));
//       await Navigator.pushNamed(context, MyRoutes.homeRoute);
//       setState(() {
//         changedButton = false;
//       });
//       }

// }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         child:Form(
//           key:_formkey,
//         child: Column(
//           children: [
//             Image.asset("assets/images/retailerloginimage.jpg", fit: BoxFit.cover),
//             const SizedBox(height: 20.0),
//              Text(
//               "Welcome $name",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20.0),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       hintText: "Enter Username",
//                       labelText: "Username",
//                     ),
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return "Username can not be empty";
//                       }
//                       return null;
//                     },
//                     onChanged: (value){
//                       name = value;
//                       setState(() {});

//                     },
//                   ),
//                   const SizedBox(height: 20.0),
//                   TextFormField(
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       hintText: "Enter Password",
//                       labelText: "Password",
//                     ),
//                      validator: (value){
//                       if(value!.isEmpty){
//                         return "Password can not be empty";
//                       }
//                       else if(value.length <6){
//                         return "Password can not be less than 6 characters";
//                       }
//                       return null;
//                     },
//                   ),
                  
//                   const SizedBox(height: 20.0),

//                 Material(
//                   color: Color.fromARGB(255, 68, 10,228),
//                   borderRadius: BorderRadius.circular(changedButton? 50: 8 ),
//                   child:InkWell(
//                   onTap:() => moveToHome(context),
//                   child:AnimatedContainer(
//                     duration: Duration(seconds: 1),
//                     child:changedButton?Icon(Icons.done , color: Colors.white,):Text("Login",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color: Colors.white)),
//                     height: 50,
//                     width: changedButton? 50:150,
                    
//                     alignment:Alignment.center,
//                   )
//                   )
//                 ),
             
//                 ],
//               )
//               ,
//             ),
//           ],
//         ),
//       ),
//       ),
//     );
//   }
// }


class LoginPageRetailer extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageRetailer> {
  bool changedButton = false;
  final _formkey = GlobalKey<FormState>();


 
  // Controllers for text fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle login
  Future<void> moveToHome(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        changedButton = true;
      });

      // Collect data from text fields
      final Map<String, String> data = {
        'email': usernameController.text,
        'password': passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:5000/retailer_login'), // Replace with your backend URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Success
          print('Login successful');

          ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Login successful!'),
      duration: Duration(seconds: 2), // Duration for the Snackbar
      backgroundColor: Colors.green, // You can customize the color
    ),
  );


          // Parse the response JSON
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);

          // Assuming 'retailer_id' and 'retailer_name' are returned in the response
          final retailerId = responseData['retailer_id'];
          final retailerName = responseData['retailer'];
          final retailerEmail=responseData['retailer_email'];

          // Save retailer_id and retailer_name to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('retailer_id', retailerId);
          await prefs.setString('retailer_name', retailerName);
          await prefs.setString('retailer_email', retailerEmail);


          // Navigate to the home page and pass retailer data
          await Navigator.pushNamed(
            context,
            '/homePage',
          );
        } else {
          // Error: Show failure dialog if login fails
          print('Login failed: ${response.body}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        // Error: Show dialog in case of network error or other exception
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during login. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        // Reset button state after the request is completed
        setState(() {
          changedButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Image.asset("assets/login_image.png", fit: BoxFit.cover),
              const SizedBox(height: 20.0),
              
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Enter Email",
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email can not be empty";
                        }
                        return null;
                      },
                      
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Password",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password can not be empty";
                        } else if (value.length < 6) {
                          return "Password can not be less than 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      color: Color.fromARGB(255, 68, 10, 228),
                      borderRadius: BorderRadius.circular(changedButton ? 50 : 8),
                      child: InkWell(
                        onTap: () => moveToHome(context),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          child: changedButton
                              ? Icon(Icons.done, color: Colors.white)
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                          height: 50,
                          width: changedButton ? 50 : 150,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
