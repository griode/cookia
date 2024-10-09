import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookia/data/model/message.dart';
import 'package:cookia/utils/router/router_config.dart';

class MessageProvider {
  static final _messageCollection =
      FirebaseFirestore.instance.collection("messages").withConverter(
            fromFirestore: Message.fromFireStore,
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Future<List<Message>> getMessages() async {
    try {
      var result = await _messageCollection
          .where("to", isEqualTo: currentUserAuth!.id)
          .get();
      return result.docs.map((doc) => doc.data()).toList();
    } catch (_) {
      return [];
    }
  }

  // Fonction qui retourne un Stream<int> du nombre de messages non lus
  static Future<int> countUnreadMessages() async {
    try {
      var agr = await  _messageCollection
          .where("to", isEqualTo: currentUserAuth!.id)
          .where("is_read", isEqualTo: false).count().get();
      return agr.count?? 0;
    } catch (_) {
      return 0;
    }
  }
}
