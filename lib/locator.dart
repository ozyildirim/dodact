import 'package:dodact_v1/repository/announcement_repository.dart';
import 'package:dodact_v1/repository/auth_repository.dart';
import 'package:dodact_v1/repository/event_repository.dart';
import 'package:dodact_v1/repository/group_repository.dart';
import 'package:dodact_v1/repository/post_repository.dart';
import 'package:dodact_v1/repository/user_repository.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_announcement_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_event_service.dart';
import 'package:dodact_v1/services/concrete/firebase_group_service.dart';
import 'package:dodact_v1/services/concrete/firebase_post_service.dart';
import 'package:dodact_v1/services/concrete/firebase_story_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseUserService());
  locator.registerLazySingleton(() => UserRepository());

  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => AuthRepository());

  locator.registerLazySingleton(() => FirebaseEventService());
  locator.registerLazySingleton(() => EventRepository());

  locator.registerLazySingleton(() => FirebasePostService());
  locator.registerLazySingleton(() => PostRepository());

  locator.registerLazySingleton(() => FirebaseGroupService());
  locator.registerLazySingleton(() => GroupRepository());

  locator.registerLazySingleton(() => FirebaseAnnouncementService());
  locator.registerLazySingleton(() => AnnouncementRepository());

  locator.registerLazySingleton(() => FirebaseStoryService());
}
