import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';

class FirebaseUserFavoritesService {
  Future<List<String>> getUserFavoritePosts(String userId) async {
    List<String> favorites = [];

    DocumentSnapshot documentSnapshot = await userFavsRef.doc(userId).get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot;
      favorites = List.castFrom(data['favoritePosts'] as List ?? []);
      print("favoriler: " + favorites.toString());
    } else {
      await userFavsRef.doc(userId).set({'favoritePosts': []});
      print("hellooo");
    }

    return favorites;
  }

  Future<void> addFavoritePost(String userId, String objectId) async {
    // Add favorite to Firebase
    await userFavsRef.doc(userId).update({
      'favoritePosts': FieldValue.arrayUnion([objectId]),
    });
  }

  Future<void> removeFavoritePost(String userId, String objectId) async {
    // Remove favorite from Firebase

    await userFavsRef.doc(userId).update({
      'favoritePosts': FieldValue.arrayRemove([objectId]),
    });
  }
}
