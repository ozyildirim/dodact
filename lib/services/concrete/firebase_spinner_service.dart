import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/spinner_result_model.dart';
import 'package:logger/logger.dart';

class FirebaseSpinnerService {
  var logger = new Logger();
  Future<List<SpinnerResultModel>> getUserSpinners(String userId) async {
    try {
      List<SpinnerResultModel> spins = [];
      QuerySnapshot querySnapshot =
          await spinnerResultsRef.where('userId', isEqualTo: userId).get();

      for (var snapshot in querySnapshot.docs) {
        var result = SpinnerResultModel.fromJson(snapshot.data());
        spins.add(result);
      }
      logger.i("Results fetched successfuly");
      return spins;
    } catch (e) {
      logger.e("Error while fetching user spins");
      return null;
    }
  }

  Future<void> addSpinnerResult(SpinnerResultModel result) async {
    try {
      await spinnerResultsRef.add(result.toJson()).then((value) async {
        await spinnerResultsRef.doc(value.id).update({'resultId': value.id});
      });
      logger.i("Spinner result added for user.");
    } catch (e) {
      logger.e("Error while adding result: " + e);
    }
  }

  // ignore: missing_return
  Future<bool> canUserUseSpinner(String userId) async {
    try {
      logger.d("İşlem başladı");
      return await spinnerResultsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          logger.e("Hiç döküman yok");
          print(value.docs.toString());
          return true;
        } else {
          logger.d("Döküman var");
          var lastSpinner = SpinnerResultModel.fromJson(value.docs[0].data());
          var lastSpinnerDate = lastSpinner.createdAt;
          var currentDate = DateTime.now();
          var difference = currentDate.difference(lastSpinnerDate);
          if (difference.inDays > 0) {
            logger.d("1 günden fazla fark var");
            return true;
          } else {
            logger.d("1 günden az fark var");
            return false;
          }
        }
      });
    } catch (e) {
      logger.e("Error while checking user spinner: " + e);
      return false;
    }
  }
}
