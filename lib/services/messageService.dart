import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class MessageService {
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  List<Map<String, dynamic>> _messageQueue = [];

  MessageService() {
    // Initialize the connectivity plugin
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Handle offline state
        print('Offline');
      } else {
        // Handle online state
        print('Online');
        sendCachedMessages();
      }
    });
  }

  void sendCachedMessages() async {
    // Retrieve messages with 'sending' status from local storage
    QuerySnapshot querySnapshot = await _messagesCollection
        .where('status', isEqualTo: 'sending')
        .get();

    // Iterate through the documents and send them to Firebase
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      try {
        // Update the status to 'sent' if the message is added successfully
        await documentSnapshot.reference.update({'status': 'sent'});
      } catch (e) {
        // Handle the error as needed.
        print('Failed to send cached message: $e');
      }
    }
  }

  Future<void> addMessage(Map<String, dynamic> messageData) async {
    // Set the initial status to "sending"
    messageData['status'] = 'sending';
    print("sending");
    try {
      DocumentReference documentReference =
      await _messagesCollection.add(messageData);

      // If the message is added successfully, update the status to "sent" in Firebase
      await documentReference.update({'status': 'sent'});
    } catch (e) {
      // Handle the error as needed.
      print('Failed to add message: $e');
    }
  }





  //
  // Stream<List<Map<String, dynamic>>> getMessagesBetweenUsers(
  //     String senderId, String receiverId,
  //     ) async* {
  //   var senderStream = _messagesCollection
  //       .where('senderId', isEqualTo: senderId)
  //       .where('receiverId', isEqualTo: receiverId)
  //       .orderBy("sentDateTime")
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) => snapshot.docs
  //       .map((DocumentSnapshot document) =>
  //   document.data() as Map<String, dynamic>)
  //       .toList());
  //
  //   var receiverStream = _messagesCollection
  //       .where('senderId', isEqualTo: receiverId)
  //       .where('receiverId', isEqualTo: senderId)
  //       .orderBy("sentDateTime")
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) => snapshot.docs
  //       .map((DocumentSnapshot document) =>
  //   document.data() as Map<String, dynamic>)
  //       .toList());
  //
  //   // Convert individual streams into an iterable and then merge
  //   final mergedStream = Rx.merge([senderStream, receiverStream]);
  //
  //   await for (var allMessages in mergedStream) {
  //     // Combine and sort the messages by "sentDateTime"
  //     allMessages.sort((a, b) =>
  //         (a["sentDateTime"] as Timestamp).compareTo(b["sentDateTime"]));
  //     yield allMessages;
  //   }
  // }

  Stream<List<Map<String, dynamic>>> getMessagesBetweenUsers(
    String senderId, String receiverId) {
  var senderMessagesStream = _messagesCollection
      .where('senderId', isEqualTo: senderId)
      .where('receiverId', isEqualTo: receiverId)
      .snapshots();

if(senderId!=receiverId) {
  var receiverMessagesStream = _messagesCollection
      .where('receiverId', isEqualTo: senderId)
      .where('senderId', isEqualTo: receiverId)
      .snapshots();

  return Rx.combineLatest2<List<QueryDocumentSnapshot>,
      List<QueryDocumentSnapshot>,
      List<Map<String, dynamic>>>(
    senderMessagesStream.map((snapshot) => snapshot.docs),
    receiverMessagesStream.map((snapshot) => snapshot.docs),
        (senderMessages, receiverMessages) {
      return [...senderMessages, ...receiverMessages]
          .map((document) => document.data() as Map<String, dynamic>)
          .toList()
        ..sort((a, b) => (b['sentDateTime'] as Timestamp).compareTo(
            a['sentDateTime'] as Timestamp));;
    },

  );
}
return senderMessagesStream
        .map(
    (QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot document) =>
    document.data() as Map<String, dynamic>)
        .toList()
      ..sort((a, b) => b['sentDateTime'].compareTo(a['sentDateTime']))
    );

}

}
