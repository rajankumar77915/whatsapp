import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/chats.dart';
import 'Login.dart';



class Otp extends StatefulWidget {
  const Otp({super.key,required this.verificationId});
  final String verificationId;

  @override
  State<Otp> createState() => _OtpState( verificationId: verificationId);
}

class _OtpState extends State<Otp> {
  final _formKey = GlobalKey<FormState>();
  int _timerValue = 60; // Initial timer value in seconds
  late Timer _timer;
  final _pinController1=TextEditingController();
  final _pinController2=TextEditingController();
  final _pinController3=TextEditingController();
  final _pinController4=TextEditingController();
  final _pinController5=TextEditingController();
  final _pinController6=TextEditingController();
  String msgCode='';
  final verificationId;
  _OtpState({required this.verificationId});


  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerValue > 0) {
          _timerValue--;
        } else {
          _timer.cancel(); // Stop the timer when it reaches 0
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }


  otpVerify() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String smsCode = _pinController1.text+_pinController2.text+_pinController3.text+_pinController4.text+_pinController5.text+_pinController6.text;
      print("code :is$smsCode");
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Chats()));
    } catch (error) {
      print("Error at otpVerify: $error");

      // Handle specific exceptions
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case "account-exists-with-different-credential":
          // Handle account exists with a different credential
            print("Account exists with a different credential.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginVerifyPhonePage()));
            // Implement logic to fetchSignInMethodsForEmail and linkWithCredential
            break;
          case "invalid-credential":
          // Handle invalid credential
            print("Invalid credential.");
            break;
          case "operation-not-allowed":
          // Handle operation not allowed
            print("Operation not allowed.");
            break;
          case "user-disabled":
          // Handle user disabled
            print("User is disabled.");
            break;
          case "user-not-found":
          // Handle user not found
            print("User not found.");
            break;
          case "wrong-password":
          // Handle wrong password
            print("Wrong password.");
            break;
          case "invalid-verification-code":
          // Handle invalid verification code
            print("Invalid verification code.");
            break;
          case "invalid-verification-id":
          // Handle invalid verification ID
            print("Invalid verification ID.");
            break;
          default:
          // Handle other FirebaseAuthExceptions or generic errors
            print("Unhandled error: $error");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child:Form(
        key: _formKey,
        child:Center(child: Container(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                child:Text("Enter verification code",style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 19,fontFamily:String.fromCharCode(1))),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                    child:TextFormField(
                    controller: _pinController1,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                      onSaved: (newValue) {

                      },
                  ),),
              ),

              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child:TextFormField(
                    controller: _pinController2,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),),
              ),

              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child:TextFormField(
                    controller: _pinController3,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),),
              ),

              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child:TextFormField(
                    controller: _pinController4,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),),
              ),

              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child:TextFormField(
                    controller: _pinController5,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),),
              ),

              SizedBox(
                height: 65,
                width: 51,
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green), // Set border color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child:TextFormField(
                    controller: _pinController6,
                    keyboardType: TextInputType.phone,
                    maxLength: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '', // Hide the default character counter
                      border: InputBorder.none, // Hide the default border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),),
              ),

            ],
            ),


                SizedBox(height: 13,),
                ElevatedButton(
                  onPressed: () {
                    // Validate the form
                    if (_formKey.currentState!.validate()) {
                      otpVerify();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set text color
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)), // Set button width and height
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Set border radius
                      ),
                    ),
                  ),
                          child: Text('Verify'),
                ),


                SizedBox(height: 10), // Add some space between the button and the timer
                Text(
                  '$_timerValue seconds remaining',
                  style: TextStyle(fontSize: 14,color: Colors.black87),
                ),
              ],
            )
    ),
        ),
        )
    ),
    );
  }
}
