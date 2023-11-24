import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  MessageService() {
    final FirebaseFirestore db;
    enableOfflinePersistence();
  }

  void enableOfflinePersistence() async {
    try {
      await FirebaseFirestore.instance.enablePersistence();
    } catch (e) {
      if (e is FirebaseException && e.code == 'failed-precondition') {
        print('Persistence failed: ${e.message}');
      } else if (e is FirebaseException && e.code == 'unimplemented') {
        print('Persistence is not supported on this platform: ${e.message}');
      }
    }
  }

  Future<void> addMessage(Map<String, dynamic> messageData) async {
    try {
      await _messagesCollection.add(messageData);
    } catch (e) {
      // Handle the error as needed.
      print('Failed to add message: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getMessagesBetweenUsers(
      String senderId, String receiverId) {
    return _messagesCollection
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .snapshots()
        .map(
          (QuerySnapshot snapshot) => snapshot.docs
          .map((DocumentSnapshot document) =>
      document.data() as Map<String, dynamic>)
          .toList(),
    );
  }
}
