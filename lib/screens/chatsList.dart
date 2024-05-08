import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/screens/inChat.dart';
import 'package:whatsapp/services/chatsService.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatsService  chatS=ChatsService();

  List<Contact> contacts=[];
  @override
  void initState() {
    super.initState();
    fetchContacts();
    //chatS.addDummyData();
  }

  Future<void> fetchContacts() async {
    // Check if permission is granted
    var status = await Permission.contacts.status;
    // chatS.addDummyData();
    if (status.isGranted) {
      // Permission is already granted, fetch contacts
      Iterable<Contact> _contacts = await ContactsService.getContacts();

      //if stored mobile number has extra space tehn removed it ,and if country code not added then add coding user's country code
      setState(() {
        contacts = _contacts.toList();

        contacts.forEach((element) {
          if (element.phones!.isNotEmpty) {
            if (!element.phones!.first!.value!.startsWith('+')) {
              element.phones!.first!.value = '+91' + element.phones!.first!.value!;
            }
            element.phones!.first!.value = element.phones!.first!.value!.replaceAll(" ", "");
          }
        });
      });
    } else {
      // Permission is not granted, request permission
      await Permission.contacts.request();
      // After permission is granted, fetch contacts
      fetchContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
     Expanded(
        child:StreamBuilder<List<String>?>(
          stream: chatS.getFriendsForUser("+"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Display your messages using the data from the snapshot
              List<String> messages = snapshot.data ?? [];
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String? contact_detail=messages[index];
                  String? phone=messages[index];
                  for (var element in contacts) {
                    if (element.phones!.isNotEmpty && element.phones!.first!.value!.startsWith(messages[index])) {
                      // Phone number starts with '929387373'
                      // You can add your logic or print a message for verification
                      print('Phone number starts with 929387373: ${element.phones!.first!.value}');
                      if(element.displayName!.isNotEmpty)
                        contact_detail=element.displayName;
                      break;
                    }
                    // else if(element.phones!.isNotEmpty){
                    //   print('Phone num: ${element.phones!.first!.value}');
                    // }
                  }
                  // Customize how each message is displayed
                  return ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>InChat(contact_detail: contact_detail,phone:phone,))), child:Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage:NetworkImage("https://rukminim2.flixcart.com/image/850/1000/xif0q/poster/y/j/s/small-baby-krishna-poster-for-pregnant-woman-300-gsm-12x18-original-imags29rkcfezh7w.jpeg?q=90")),
                      title: Text("${contact_detail}" ),
                      subtitle: Text('Here is a second line',style: TextStyle(color: Colors.white),),
                    ),
                  ), );
                },
              );
            }
          },
        ),
    ),
        ],
    );
  }
}
