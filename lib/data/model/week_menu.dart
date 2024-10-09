import 'package:cloud_firestore/cloud_firestore.dart';

class WeekMenu {
  final String userId;
  final Timestamp createdAt;
  final Map<String, dynamic> menu;

  WeekMenu({required this.userId, required this.createdAt, required this.menu});

  toFirestore() {
    return {
      'user_id': userId,
      'created_at': createdAt,
      'menu': menu,
    };
  }

  factory WeekMenu.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return WeekMenu(
      userId: data!['user_id'],
      createdAt: Timestamp.now(),
      menu: data['menu'],
    );
  }
}
