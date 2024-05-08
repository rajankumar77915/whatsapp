import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp/screens/otp.dart';


void phoneVerification(BuildContext context,String countryCode,String  phoneNo)async{
  try {
  print("omomomomomomom ${countryCode+phoneNo}");
    FirebaseAuth auth = FirebaseAuth.instance;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+"+countryCode+phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            // Fluttertoast.cancel();
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "invalid-phone-number",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            print('The provided phone number is not valid.');
          }
        },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Otp(verificationId: verificationId,)),
        );


      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }catch(e){
  print(e);
  }
}
