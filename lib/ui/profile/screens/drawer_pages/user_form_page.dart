import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_form_model.dart';
import 'package:dodact_v1/services/concrete/firebase_user_form_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class UserFormPage extends StatefulWidget {
  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends BaseState<UserFormPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  List<String> types = ["Şikayet", "Öneri", "Bildiri"];

  FocusNode dropdownFocusNode = FocusNode();
  FocusNode formFocus = FocusNode();

  @override
  void dispose() {
    dropdownFocusNode.dispose();
    formFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: submitForm,
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Öneriler ve Bildiriler'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: buildForm(),
        ),
      ),
    );
  }

  buildForm() {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tür",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFieldContainer(
                    width: size.width * 0.9,
                    child: FormBuilderDropdown(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // focusNode: postDescriptionFocus,
                      // controller: postDescriptionController,
                      name: "type",
                      autofocus: false,
                      items: types
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                          hintText: "Tür",
                          border: InputBorder.none,
                          errorStyle: Theme.of(context)
                              .inputDecorationTheme
                              .errorStyle),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            context,
                            errorText: "Bu alan boş bırakılamaz.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Açıklama",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFieldContainer(
                    width: size.width * 0.9,
                    child: FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // focusNode: postDescriptionFocus,
                      // controller: postDescriptionController,
                      name: "description",
                      autofocus: false, maxLines: 10,
                      decoration: InputDecoration(
                          hintText: "Açıklama ",
                          border: InputBorder.none,
                          errorStyle: Theme.of(context)
                              .inputDecorationTheme
                              .errorStyle),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            context,
                            errorText: "Bu alan boş bırakılamaz.",
                          ),
                          FormBuilderValidators.minLength(context, 30,
                              errorText: "En az 30 karakter girin.",
                              allowEmpty: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  submitForm() async {
    var _firebaseFormService = FirebaseUserFormService();
    if (_formKey.currentState.saveAndValidate()) {
      var type = _formKey.currentState.value['type'];
      var description = _formKey.currentState.value['description'];

      var model = UserFormModel(
          creationDate: DateTime.now(),
          message: description,
          type: type,
          userId: userProvider.currentUser.uid);

      await _firebaseFormService.sendUserForm(model).then((value) async {
        await CustomMethods()
            .showSuccessDialog(context, "Form başarıyla gönderildi!");
        Get.back();
      }).catchError((error) {
        CustomMethods().showErrorDialog(context, "Bir hata oluştu!");
      });
    }
  }
}
