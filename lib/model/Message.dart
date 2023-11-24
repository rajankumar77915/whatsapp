import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String ?message;
  String ?media;
  String senderId;
  String receiverId;
  bool receiverDelete;
  bool senderDelete;
  DateTime sentDateTime;
  DateTime receiveDateTime;
  bool read;
  List<String> ?status;

  Message({
     this.message,
     this.media,
    required this.senderId,
    required this.receiverId,
     this.receiverDelete=false,
     this.senderDelete=false,
    required this.sentDateTime,
    required this.receiveDateTime,
     this.read=false,
     this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      media: json['media'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      receiverDelete: json['receiverDelete'],
      senderDelete: json['senderDelete'],
      sentDateTime: (json['sentDateTime'] as Timestamp).toDate(),
      receiveDateTime: DateTime.parse(json['receiveDateTime']),
      read: json['read'],
      status: List<String>.from(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'media': media,
      'senderId': senderId,
      'receiverId': receiverId,
      'receiverDelete': receiverDelete,
      'senderDelete': senderDelete,
      'sentDateTime': sentDateTime,
      'receiveDateTime': receiveDateTime,
      'read': read,
      'status': status,
    };
  }
}
