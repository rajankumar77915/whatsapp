import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/user.dart';

class ChatsService{
  final CollectionReference _ChatsCollection =
  FirebaseFirestore.instance.collection('users');

  Stream<List<String>?> getFriendsForUser(String userId) {
    return _ChatsCollection
        .where("mobile", isEqualTo: userId)
        .snapshots()
        .map(
          (QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Assuming "friends" is a field in the user document
          List<String>? friends =
          (snapshot.docs.first.data() as Map<String, dynamic>)['friends']
              ?.cast<String>();
          print("got");
          return friends;
        } else {
          // User document not found
          print('User document not found for userId: $userId');
          return null;
        }
      },
    );
  }


  Future<void> addDummyData() async {
    // Dummy data for a user
    User dummyUser = User(
      firstName: 'John',
      lastName: 'Doe',
      mobile: '+918141017088',
      friends: ['+9876543210', '+917567282673',"+9181410"], // Add mobile numbers of friends
      calls: ['+9876543210'], // Add mobile numbers of calls
      description: 'This is a dummy user.',
    );


    // Convert User object to a map
    Map<String, dynamic> userMap = dummyUser.toMap();

    // Add the dummy data to the collection
    await _ChatsCollection.add(userMap);
    print("sucess");

  }
}
