import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserObject user);
  Future<UserObject> readUser(String userID);
  Future<List<PostModel>> getAllPosts(String category);
  Future<List<PostModel>> getUserPosts(UserObject user);
  Future<PostModel> getPostById(String postID);
}
