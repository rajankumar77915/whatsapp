
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whatsapp/model/country.dart';
import 'package:whatsapp/services/phoneverification.dart';



class LoginVerifyPhonePage extends StatefulWidget {
  @override
  _LoginVerifyPhonePageState createState() => _LoginVerifyPhonePageState();
}

class _LoginVerifyPhonePageState extends State<LoginVerifyPhonePage> {
  late List<Country> countries;
  String selectedCountryCode = '';
  bool countriesGot=false;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountryCodes();
  }

  Future<void> _loadCountryCodes() async {
    // Load country codes from JSON file
    final response = await DefaultAssetBundle.of(context)
        .loadString('countryPhoneCodes.json');
    final decoded = json.decode(response);

    // Convert decoded data to a list of Country objects
    List<Country> countryList = List<Country>.from(
      decoded.map((model) => Country(
        country: model['country'],
        code: model['code'],
        iso: model['iso'],
      )),
    );

    // Update the state with the initialized countries list
    setState(() {
      countries = countryList;
      selectedCountryCode = countryList[94].code;
      countriesGot =true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Login Verify Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(countriesGot)
            DropdownButtonFormField<String>(
              value: selectedCountryCode,
              onChanged: (String? value) {
                setState(() {
                  selectedCountryCode = value!;
                });
              },
              items: countries
                  .map<DropdownMenuItem<String>>(
                    (Country country) => DropdownMenuItem<String>(
                  value: country.code,
                  child: Text('${country.country} (+${country.code})'),
                ),
              )
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Country',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration:const InputDecoration(
                labelText: 'Phone Number',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Container(
              width: 20,
            child:ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder:  (BuildContext context) {
                  return
                    const AlertDialog(
                    backgroundColor: Colors.transparent,
                      titlePadding: EdgeInsets.all(16.0),
                      contentPadding: EdgeInsets.all(16.0),
                      content: Column(
                      mainAxisSize:MainAxisSize.min,
                      children: [
                        SizedBox(
                          width:90,
                        child:LoadingIndicator(
                          indicatorType: Indicator.orbit,
                          colors: const [Colors.deepOrange],
                          strokeWidth: 0.1,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black,
                        ),
                        ),
                        SizedBox(height: 16.0),
                        Text("Sending Verification Code...",style: TextStyle(color: Colors.white60)),
                      ],
                    ),
                  );
                });
                print("ookokokokokokokok");
                phoneVerification(context,selectedCountryCode,phoneNumberController.text);
              },
              child:const Text('Send Verificatin code'),
              style: ElevatedButton.styleFrom(

                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)) ,
                textStyle: TextStyle(color: Colors.white), // Text color
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: LoginVerifyPhonePage(),
    ),
  );
}
