import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String to;
  final String message;
  final List<String> image; // Assuming image is a list of URLs or paths
  final String deviceToken;
  final String subject;
  final Timestamp date;
  final bool isRead;

  Message({
    required this.to,
    required this.message,
    required this.image,
    required this.deviceToken,
    required this.subject,
    required this.date,
    required this.isRead,
  });

  // Méthode pour convertir l'objet en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'to': to,
      'message': message,
      'image': image,
      'device_token': deviceToken,
      'subject': subject,
      'date': date,
      'is_read': isRead,
    };
  }

  // Factory constructor pour créer une instance de Message à partir d'un DocumentSnapshot Firestore
  factory Message.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      to: data!['to'],
      message: data['message'],
      image: List<String>.from(
          data['image']), // Convertir la liste Firestore en liste Dart
      deviceToken: data['device_token'],
      subject: data['subject'],
      date: data['date'] as Timestamp,
      isRead: data['is_read'] as bool,
    );
  }
}
