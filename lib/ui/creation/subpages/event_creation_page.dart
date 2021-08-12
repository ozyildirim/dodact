import 'dart:io';

import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventCreationPage extends StatefulWidget {
  final String eventCategory;
  final String eventType;
  final String eventPlatform;

  EventCreationPage({this.eventCategory, this.eventType, this.eventPlatform});

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends BaseState<EventCreationPage> {
  List<File> _eventImages;
  String eventCoordinates;

  EventProvider _eventProvider;

  GlobalKey<FormBuilderState> _formKey = new GlobalKey<FormBuilderState>();
  TextEditingController _eventTitleController = new TextEditingController();
  TextEditingController _eventDescriptionController =
      new TextEditingController();
  TextEditingController _eventContentUrlController =
      new TextEditingController();
  TextEditingController _eventDateController = new TextEditingController();
  TextEditingController _eventURLController = new TextEditingController();
  TextEditingController _eventLocationController = new TextEditingController();

  FocusNode _eventTitleFocus = new FocusNode();
  FocusNode _eventDescriptionFocus = new FocusNode();
  FocusNode _eventURLFocus = new FocusNode();

  DateTime _eventStartDate = new DateTime.now();
  DateTime _eventEndDate = new DateTime.now().add(Duration(days: 1));
  bool isOnline;
  String postOwnerType = "User";
  String ownerGroupId;

  PickResult selectedPlace;

  @override
  void dispose() {
    super.dispose();
    _eventDescriptionFocus.dispose();
    _eventTitleFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    _eventProvider = Provider.of<EventProvider>(context, listen: false);
    _eventProvider.clearNewEvent();
    isOnline = widget.eventPlatform == 'Online Etkinlik' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _formSubmit();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Etkinlik Oluştur'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildEventImagePart(),
              _buildEventFormPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImagePart() {
    if (_eventImages == null) {
      return Expanded(
        child: Container(
          height: 250,
          width: 250,
          child: IconButton(
            onPressed: () async {
              await _selectFiles();
            },
            icon: Icon(FontAwesome5Solid.camera),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Stack(
          children: [
            GFItemsCarousel(
              rowCount: 2,
              children: _eventImages.map((file) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(file),
                  )),
                );
              }).toList(),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: IconButton(
                      onPressed: () async {
                        _selectFiles();
                      },
                      icon: Icon(FontAwesome5Solid.plus)),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildEventFormPart() {
    var size = MediaQuery.of(context).size;
    return Expanded(
      flex: 4,
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Etkinlik Adı",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: _eventTitleFocus,
                    name: "eventTitle",
                    keyboardType: TextInputType.text,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.people_alt_sharp,
                          color: kPrimaryColor,
                        ),
                        hintText: "Etkinlik Adı",
                        border: InputBorder.none,
                        errorStyle:
                            Theme.of(context).inputDecorationTheme.errorStyle),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context,
                            errorText: "Bu alan boş bırakılamaz.")
                      ],
                    ),
                  ),
                ),
                Text("Etkinlik Açıklaması",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: _eventDescriptionFocus,
                    name: "eventDescription",
                    keyboardType: TextInputType.text,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.people_alt_sharp,
                          color: kPrimaryColor,
                        ),
                        hintText: "Etkinlik Açıklaması",
                        border: InputBorder.none,
                        errorStyle:
                            Theme.of(context).inputDecorationTheme.errorStyle),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context,
                            errorText: "Bu alan boş bırakılamaz.")
                      ],
                    ),
                  ),
                ),
                Text("Etkinlik Başlangıç Tarihi",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                TextFieldContainer(
                  key: Key(DateFormat("dd/mm/yyyy").format(_eventStartDate)),
                  width: size.width * 0.6,
                  child: FormBuilderDateTimePicker(
                    initialValue: _eventStartDate,
                    format: DateFormat("dd/MM/yyyy hh:mm"),
                    onChanged: (date) {
                      setState(() {
                        _eventStartDate = date;
                      });
                    },
                    initialDate: _eventStartDate,
                    alwaysUse24HourFormat: true,
                    name: "eventStartDate",
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesome5Solid.calendar,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                    confirmText: "Tamam",
                    cancelText: "İptal",
                    fieldLabelText: "Etkinlik Başlangıç Tarihi",
                    helpText: "Etkinlik tarihini seçiniz",
                    fieldHintText: "Gün/Ay/Yıl",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz."),
                    ]),
                    firstDate: DateTime.now(),
                  ),
                ),
                Text("Etkinlik Bitiş Tarihi",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                TextFieldContainer(
                  key: Key(DateFormat("dd/mm/yyyy").format(_eventEndDate)),
                  width: size.width * 0.6,
                  child: FormBuilderDateTimePicker(
                    initialValue: _eventEndDate,
                    format: DateFormat("dd/MM/yyyy hh:mm"),
                    onChanged: (date) {
                      setState(() {
                        _eventEndDate = date;
                      });
                    },
                    initialDate: _eventStartDate,
                    alwaysUse24HourFormat: true,
                    name: "eventEndDate",
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesome5Solid.calendar,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz."),
                    ]),
                  ),
                ),
                Text(isOnline ? "Etkinlik Adresi" : "Etkinlik Lokasyonu",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                isOnline
                    ? TextFieldContainer(
                        width: size.width * 0.6,
                        child: FormBuilderTextField(
                          textInputAction: TextInputAction.next,
                          focusNode: _eventURLFocus,
                          name: "eventURL",
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.play_lesson_outlined,
                                color: kPrimaryColor,
                              ),
                              hintText: "Etkinlik İnternet Adresi",
                              border: InputBorder.none,
                              errorStyle: Theme.of(context)
                                  .inputDecorationTheme
                                  .errorStyle),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(context,
                                  errorText: "Bu alan boş bırakılamaz."),
                              FormBuilderValidators.url(context)
                            ],
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          TextFieldContainer(
                            width: size.width * 0.6,
                            child: FormBuilderTextField(
                              controller: _eventLocationController,
                              readOnly: true,
                              name: "eventLocation",
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              cursorColor: kPrimaryColor,

                              decoration: InputDecoration(
                                  icon: Icon(
                                    FontAwesome5Regular.map,
                                    color: kPrimaryColor,
                                  ),
                                  hintText: "Etkinlik Lokasyonu",
                                  border: InputBorder.none,
                                  errorStyle: Theme.of(context)
                                      .inputDecorationTheme
                                      .errorStyle),
                              // validator: FormBuilderValidators.compose(
                              //   [
                              //     FormBuilderValidators.required(context,
                              //         errorText: "Bu alan boş bırakılamaz.")
                              //   ],
                              // ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await _showLocationPicker();
                              },
                              icon: Icon(Icons.location_on)),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectFiles() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      //Seçilen fotoğrafları listeye ekliyoruz.
      _eventImages = result.paths.map((path) {
        return File(path);
      }).toList();

      //UI yenilenmesi için setState yapıyoruz.

      print("Fotoğraflar seçildi");
      setState(() {});
    } else {
      print("Fotoğraflar seçilmedi");
    }
  }

  Future _showLocationPicker() async {
    final kInitialPosition = LatLng(-33.8567844, 151.213108);
    // print("asdasd");
    PickResult result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: "AIzaSyCcalb7hxJiha_uKPo7a1L4LuMNig7L_cE",
          onPlacePicked: (result) {
            setState(() {
              selectedPlace = result;
            });

            Navigator.of(context).pop();
          },
          forceSearchOnZoomChanged: true,
          automaticallyImplyAppBarLeading: false,
          autocompleteLanguage: "tr",
          region: 'tr',
          selectInitialPosition: true,
          selectedPlaceWidgetBuilder:
              (_, selectedPlace, state, isSearchBarFocused) {
            print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            return isSearchBarFocused
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        backgroundColor: Colors.cyan[300],
                        onPressed: () {
                          Navigator.of(context).pop(selectedPlace);
                        },
                        child: Text(
                          "Seç",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "Raleway"),
                        ),
                      ),
                    ),
                  );
          },
          initialPosition: kInitialPosition,
          useCurrentLocation: true,
          pinBuilder: (context, state) {
            if (state == PinState.Idle) {
              return Icon(Icons.favorite_border);
            } else {
              return Icon(Icons.favorite);
            }
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        selectedPlace = result;
        _eventLocationController.text = selectedPlace.formattedAddress;
      });
    } else {
      Logger().e("PlacePicker result is null");
    }
  }

  Future<void> _formSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      try {
        await createEvent();
      } catch (e) {}
    }
  }

  Future<void> createEvent() async {
    try {
      CommonMethods().showLoaderDialog(context, "Etkinlik oluşturuluyor.");
      setNewEventValues();

      await _eventProvider.addEvent(_eventImages).then((_) {
        NavigationService.instance.pop();
        // CommonMethods().showLoaderDialog(context, "Etkinlik oluşturuldu.");
        NavigationService.instance.navigateToReset(k_ROUTE_HOME);
      });
    } catch (e) {
      print("EventCreationPage error $e ");
      print(e.toString());
      NavigationService.instance.pop();
      CommonMethods().showErrorDialog(context, "Etkinlik oluşturulamadı.");
    }
  }

  void setNewEventValues() {
    _eventProvider.newEvent.approved = false;
    _eventProvider.newEvent.eventId = "";
    _eventProvider.newEvent.eventTitle =
        _formKey.currentState.value['eventTitle'].toString().trim();

    _eventProvider.newEvent.eventDescription =
        _formKey.currentState.value['eventDescription'].toString().trim();

    //TODO: Start Date ve End Date farkını ayarla

    _eventProvider.newEvent.eventStartDate = _eventStartDate;
    _eventProvider.newEvent.isDone = false;
    _eventProvider.newEvent.isOnline = isOnline;
    _eventProvider.newEvent.eventURL = isOnline
        ? _formKey.currentState.value['eventURL'].toString().trim()
        : "";

    _eventProvider.newEvent.eventLocationCoordinates =
        isOnline ? "" : eventCoordinates;

    if (postOwnerType == "User") {
      _eventProvider.newEvent.ownerId = authProvider.currentUser.uid;
      _eventProvider.newEvent.ownerType = "User";
    } else if (postOwnerType == "Group") {
      _eventProvider.newEvent.ownerId = ownerGroupId;
      _eventProvider.newEvent.ownerType = "Group";
    }

    //TODO: Bu lokasyondan elde edilecek.
    _eventProvider.newEvent.city = "";
    _eventProvider.newEvent.eventCategory = widget.eventCategory;
    _eventProvider.newEvent.eventType = widget.eventType;
  }

  //TODO: UPLOAD EDİLDİKTEN SONRA GEÇİCİ DOSYALAR SİLİNMELİ
}
