import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/user_form_model.dart';

class FirebaseUserFormService {
  Future sendUserForm(UserFormModel form) async {
    await userFormsRef.add(form.toJson()).then((value) async {
      await userFormsRef.doc(value.id).update({
        'formId': value.id,
      });
    });
  }
}
