import 'package:flutter/material.dart';
import 'package:whatsapp/Model/Message.dart';

import 'package:whatsapp/services/messageService.dart';

class InChat extends StatefulWidget {
  const InChat({Key? key}) : super(key: key);

  @override
  State<InChat> createState() => _InChatState();
}

class _InChatState extends State<InChat> {
  String? name = "krishna";
  MessageService messageService = MessageService();
  TextEditingController _messageController= TextEditingController();
  // dummy data
  /*
  Message message = Message(
    message: "kokok",
    media: "media",
    senderId: "senderId1",
    receiverId: "receiverId1",
    receiverDelete: false,
    senderDelete: false,
    sentDateTime: DateTime.now(),
    receiveDateTime: DateTime.now(),
    read: true,
  );
*/
  // Add a message
  addMessage(Message message) async {
    Map<String, dynamic> messageData = message.toJson();
    await messageService.addMessage(messageData);
    print("wownjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://rukminim2.flixcart.com/image/850/1000/xif0q/poster/y/j/s/small-baby-krishna-poster-for-pregnant-woman-300-gsm-12x18-original-imags29rkcfezh7w.jpeg?q=90"),
                ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    Text("krishna"),
                    Text("last seen", style: TextStyle(fontSize: 14),)
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed:() {
                  print("video calling");
                },icon: Icon( Icons.videocam)),
                SizedBox(width: 7,),
                Icon(Icons.phone),
                SizedBox(width: 7,),
                Icon(Icons.more_vert)
              ],
            ),
          ],
        ),
      ),
      body:
      Column(
        children:
        [
          Expanded(child:
      StreamBuilder<List<Map<String, dynamic>>>(
        stream: messageService.getMessagesBetweenUsers("senderId", "receiverId"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display your messages using the data from the snapshot
            List<Map<String, dynamic>> messages = snapshot.data ?? [];
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Customize how each message is displayed
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 0),
                  title: Text(messages[index]['message']),
                    subtitle: Text(messages[index]['sentDateTime'].toString()),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
          ),

      Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration:const InputDecoration(
                  hintText: 'Type your message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Add your code to send the message
                if (_messageController.text.isNotEmpty) {
                  // Create a new Message object with the entered text
                  Message newMessage = Message(message: _messageController.text, receiveDateTime: DateTime.now(), receiverId: "receiverId", senderId: "senderId", sentDateTime: DateTime.now(),);
                  // Add the message to the database
                  addMessage(newMessage);
                  // Clear the text field
                  _messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }
}
