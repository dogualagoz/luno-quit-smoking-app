import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';

final firestoreRepositoryProvider = Provider((ref) => FirestoreRepository());

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Profili kaydet
  Future<void> saveProfile(UserProfile profile) async {
    if (profile.userId == null) return;
    await _firestore
        .collection('users')
        .doc(profile.userId)
        .set(profile.toJson());
  }

  // Profili getir
  Future<UserProfile?> fetchProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserProfile.fromJson(doc.data()!);
    }
    return null;
  }
}
