

import 'package:whatsapp/Model/status.dart';

class User{
  final String firstName;
  final String lastName;
  final String mobile;  //my mobile number
  final List<String> ?friends;//for chats-screen friends OR unknown number   if sent/receive message then add
   List<Status> ?status; //my today status
  final List<String> calls; // my call history
  final String description; // about me


  User({required this.firstName,required this.lastName,required this.mobile, this.status,required this.calls,required this.description,this.friends});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'friends':friends,
      "status":status,
      "calls":calls,
      "decribtion":description
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      lastName: map['lastName'],
      mobile: map['mobile'],
      friends: map['friends'],
      status: List<Status>.from(
        map['status']?.map((x) => Status.fromMap(x)) ?? [],
      ),
      calls: map['calls'],
      description: map['description'],
    );
  }


}