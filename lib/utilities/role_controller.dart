import 'package:dodact_v1/model/user_model.dart';

class RoleController {
  static bool canUserCreatePost(UserObject user) {
    if (user.permissions['create_post'] == true) {
      return true;
    }
    return false;
  }

  static bool canUserCreateEvent(UserObject user) {
    if (user.permissions['create_event'] == true) {
      return true;
    }
    return false;
  }

  static bool canUserCreateGroup(UserObject user) {
    if (user.permissions['create_group'] == true) {
      return true;
    }
    return false;
  }

  static bool canUserCreateComment(UserObject user) {
    if (user.permissions['create_comment'] == true) {
      return true;
    }
    return false;
  }

  static bool canUserCreateRoom(UserObject user) {
    if (user.permissions['create_room'] == true) {
      return true;
    }
    return false;
  }

  static bool canUserCreateStream(UserObject user) {
    if (user.permissions['create_stream'] == true) {
      return true;
    }
    return false;
  }
}
