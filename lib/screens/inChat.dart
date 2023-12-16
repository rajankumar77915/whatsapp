import 'package:flutter/material.dart';
import 'package:whatsapp/Model/Message.dart';

import 'package:whatsapp/services/messageService.dart';

class InChat extends StatefulWidget {
  final String? contact_detail;
  final phone;
  const InChat({Key? key, required this.contact_detail,required this.phone}) : super(key: key);

  @override
  State<InChat> createState() => _InChatState(contact_detail: contact_detail,friend_phone: phone);
}

class _InChatState extends State<InChat> {
  final String? contact_detail;
  final friend_phone;
   String senderId="+917567282";
  _InChatState({required this.friend_phone,required this.contact_detail});
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
             Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://rukminim2.flixcart.com/image/850/1000/xif0q/poster/y/j/s/small-baby-krishna-poster-for-pregnant-woman-300-gsm-12x18-original-imags29rkcfezh7w.jpeg?q=90"),
                ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    Text(contact_detail is String ? contact_detail as String : ""),
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
            stream: messageService.getMessagesBetweenUsers(senderId, friend_phone),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("circularrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print("erorororororoororororororoorororororororoorororororororororororororoororororoorororoor");
                return Text('Error: ${snapshot.error}');
              } else {
                print("ggggggggggggggggooooooooooooooooooooooooooooooooottttttttttttttttttttttttttttttt${snapshot.data?.length}");
                // Display your messages using the data from the snapshot
                List<Map<String, dynamic>> messages = snapshot.data ?? [];
                return ListView.builder(
                  reverse: true,//for start below message
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == senderId;
                    print("flkffkofk jfijfijfifjijfijgijgigjgijgigjigjgijgigjigjgijgijgigjigjgijgigjig");
                    return Container(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      padding: EdgeInsets.only(top:10),
                      child: Row(
                        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 250),
                            child: Column(
                              children: [
                                Align(
                                  alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius:BorderRadiusDirectional.circular(10),color: Colors.black),
                                    // color: Colors.redAccent,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      message['message'],
                                      textAlign: isSender ? TextAlign.right : TextAlign.left,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                if(isSender)
                                      Container(
                                        alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
                                        child: message['status'] == "sent"
                                            ? const Icon(Icons.check, color: Colors.black87)
                                            : const Icon(Icons.access_alarm_outlined, color: Colors.black87),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                      Message newMessage = Message(message: _messageController.text, receiveDateTime: DateTime.now(), receiverId: friend_phone, senderId:senderId, sentDateTime: DateTime.now(),);
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
