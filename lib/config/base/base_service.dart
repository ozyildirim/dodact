import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseService<T> {
  Future<void> save(T model);
  Future<T> getDetail(String id);
  Future<List<T>> getList();
  Query getListQuery();
  Future<void> delete(String id);
  Future<void> update(String id, Map<String, dynamic> changes);
}
