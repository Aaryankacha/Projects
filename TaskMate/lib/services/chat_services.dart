import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final chatId = getChatId(senderId, receiverId);
    final timestamp = Timestamp.now();

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'text': text,
          'senderId': senderId,
          'receiverId': receiverId,
          'timestamp': timestamp,
        });

    await _firestore.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
      'lastMessage': text,
      'lastTimestamp': timestamp,
    }, SetOptions(merge: true)); 
  }

  Stream<QuerySnapshot> getMessagesStream(String uid1, String uid2) {
    final chatId = getChatId(uid1, uid2);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getInbox(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  Future<List<String>> getChatUserIds(String currentUserId) async {
    final chatsSnapshot = await _firestore.collection('chats').get();
    final chatUserIds = <String>{};

    for (var doc in chatsSnapshot.docs) {
      final chatId = doc.id;
      if (chatId.contains(currentUserId)) {
        final otherId = chatId
            .replaceAll(currentUserId, '')
            .replaceAll('_', '');
        if (otherId != currentUserId && otherId.isNotEmpty) {
          chatUserIds.add(otherId);
        }
      }
    }

    return chatUserIds.toList();
  }
}
