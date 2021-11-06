import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/services/concrete/firebase_user_favorites_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserFavoritesRepository {
  FirebaseUserFavoritesService firebaseUserFavoritesService =
      locator<FirebaseUserFavoritesService>();

  AppMode appMode = AppMode.RELEASE;

  Future<List<String>> getUserFavoritePosts(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<String>.empty());
    }
    return await firebaseUserFavoritesService.getUserFavoritePosts(userId);
  }

  Future<void> addFavoritePost(String userId, String objectId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value();
    }
    await firebaseUserFavoritesService.addFavoritePost(userId, objectId);
  }

  Future<void> removeFavoritePost(String userId, String objectId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value();
    }
    await firebaseUserFavoritesService.removeFavoritePost(userId, objectId);
  }
}
