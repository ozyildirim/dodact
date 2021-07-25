import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final CollectionReference usersRef = firestore.collection('users');
final CollectionReference postsRef = firestore.collection('posts');
final CollectionReference eventsRef = firestore.collection('events');
final CollectionReference announcementsRef =
    firestore.collection('announcements');
final CollectionReference groupsRef = firestore.collection('groups');
final CollectionReference storiesRef = firestore.collection('stories');
final CollectionReference reportsRef = firestore.collection('reports');
final CollectionReference requestsRef = firestore.collection('requests');
