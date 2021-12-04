import 'dart:io';
import 'dart:math';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EventCreationPage extends StatefulWidget {
  final String eventCategory;
  final String eventType;
  final bool eventPlatform;
  final String groupId;

  EventCreationPage(
      {this.eventCategory, this.eventType, this.eventPlatform, this.groupId});

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends BaseState<EventCreationPage> {
  GlobalKey<FormBuilderState> _eventFormKey = new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _eventScaffoldKey = GlobalKey<ScaffoldState>();
  EventProvider eventProvider;

  var logger = Logger();
  List<File> _eventImages = [];
  String eventCoordinates;
  String eventCity;

  TextEditingController _eventLocationController = new TextEditingController();

  FocusNode eventTitleFocus = new FocusNode();
  FocusNode eventDescriptionFocus = new FocusNode();
  FocusNode eventURLFocus = new FocusNode();
  FocusNode checkboxFocus = new FocusNode();
  FocusNode dropdownFocus = FocusNode();

  DateTime currentDate = new DateTime.now();
  DateTime nextPossibleDate = new DateTime.now().add(Duration(minutes: 1));

  DateTime startDate;

  bool isOnline;
  String ownerType;
  String ownerId;

  PickResult selectedPlace;

  String eventHint;

  @override
  void dispose() {
    super.dispose();
    eventDescriptionFocus.dispose();
    eventTitleFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    eventProvider = Provider.of<EventProvider>(context, listen: false);
    isOnline = widget.eventPlatform;
    eventHint = getRandomEventTitle();

    if (widget.groupId != null) {
      ownerType = "Group";
      ownerId = widget.groupId;
    } else {
      ownerType = "User";
      ownerId = authProvider.currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: _formSubmit,
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildEventFormPart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventFormPart() {
    var size = MediaQuery.of(context).size;
    return FormBuilder(
      key: _eventFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Etkinlik Başlığı",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFieldContainer(
                width: size.width * 0.9,
                child: FormBuilderTextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  focusNode: eventTitleFocus,
                  name: "eventTitle",
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: eventHint,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                      (value) {
                        return ProfanityChecker.profanityValidator(value);
                      },
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Başlangıç",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFieldContainer(
                    width: size.width * 0.4,
                    child: FormBuilderDateTimePicker(
                      // textAlign: TextAlign.center,
                      format: DateFormat("dd/MM/yyyy hh:mm"),
                      alwaysUse24HourFormat: true,

                      name: "eventStartDate",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: DateFormat("dd/MM/yyyy hh:mm")
                            .format(currentDate)
                            .toString(),
                        // border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        startDate = value;
                      },
                      confirmText: "Tamam",
                      initialDate: currentDate,
                      firstDate: currentDate,
                      cancelText: "İptal",
                      fieldLabelText: "Etkinlik Başlangıç Tarihi",
                      helpText: "Bir başlangıç tarihi seç",
                      fieldHintText: "Gün/Ay/Yıl",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Bir başlangıç tarihi seçmelisin"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bitiş",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFieldContainer(
                    width: size.width * 0.4,
                    child: FormBuilderDateTimePicker(
                      // textAlign: TextAlign.center,
                      helpText: "Bir bitiş tarihi seç",
                      format: DateFormat("dd/MM/yyyy hh:mm"),
                      alwaysUse24HourFormat: true,
                      name: "eventEndDate",

                      initialDate: nextPossibleDate,
                      firstDate: nextPossibleDate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: DateFormat("dd/MM/yyyy hh:mm")
                            .format(nextPossibleDate)
                            .toString(),
                        // border: InputBorder.none,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Bir tarih seçmelisin."),
                        (value) {
                          return checkDateRange(value);
                        }
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Açıklama",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFieldContainer(
                width: size.width * 0.9,
                child: FormBuilderTextField(
                  textInputAction: TextInputAction.next,
                  focusNode: eventDescriptionFocus,
                  name: "eventDescription",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: kPrimaryColor,
                  maxLines: 2,
                  decoration: InputDecoration(
                      hintText: "Etkinlik Açıklaması",
                      border: InputBorder.none,

                      // border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                      (value) {
                        return ProfanityChecker.profanityValidator(value);
                      },
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          isOnline
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Web Adresi",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFieldContainer(
                      width: size.width * 0.9,
                      child: FormBuilderTextField(
                        textInputAction: TextInputAction.next,
                        focusNode: eventURLFocus,
                        name: "eventURL",
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                            // icon: Icon(
                            //   Icons.play_lesson_outlined,
                            //   color: kPrimaryColor,
                            // ),
                            border: InputBorder.none,
                            hintText: "dodact.com",
                            // border: InputBorder.none,
                            errorStyle: Theme.of(context)
                                .inputDecorationTheme
                                .errorStyle),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              context,
                              errorText: "Bu alan boş bırakılamaz.",
                            ),
                            (value) {
                              return ProfanityChecker.profanityValidator(value);
                            },
                            FormBuilderValidators.url(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lokasyon",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: size.width * 0.4,
                          child: FormBuilderDropdown(
                              focusNode: dropdownFocus,
                              hint: Text("Şehir Seçin"),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              name: "location",
                              items: cities
                                  .map((city) => DropdownMenuItem(
                                        value: city,
                                        child: Text('$city'),
                                      ))
                                  .toList(),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: "Bir şehir seçmelisin.")
                              ])),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Konum",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            TextFieldContainer(
                              width: size.width * 0.4,
                              child: FormBuilderTextField(
                                onTap: _showMapPicker,
                                key: selectedPlace != null
                                    ? Key(selectedPlace.formattedAddress)
                                    : null,
                                readOnly: true,
                                name: "mapLocation",
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                cursorColor: kPrimaryColor,
                                initialValue: selectedPlace != null
                                    ? selectedPlace.formattedAddress
                                    : "",
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Etkinlik Konumu",
                                    suffixIcon: Icon(Icons.location_on),
                                    errorStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .errorStyle),
                                validator: (value) {
                                  if (selectedPlace == null) {
                                    return "Bir konum belirtmelisin";
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fotoğraflar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Container(
                width: size.width * 0.9,
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _eventImages.length + 1,
                  padding: EdgeInsets.only(right: 8),
                  itemBuilder: (context, index) {
                    if (_eventImages.length == 0) {
                      return GestureDetector(
                        onTap: _selectFiles,
                        child: Container(
                          height: size.height * 0.1,
                          width: size.width * 0.25,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  Icon(Icons.camera_alt, color: Colors.grey)),
                        ),
                      );
                    } else {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: _selectFiles,
                          child: Container(
                              height: size.height * 0.1,
                              width: size.width * 0.25,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.grey))),
                        );
                      }
                      var image = _eventImages[index - 1];
                      return Stack(
                        children: [
                          Container(
                            height: 100,
                            width: size.width * 0.25,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 13,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    removePickedFile(image);
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 20,
                                  )),
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  checkDateRange(DateTime endDate) {
    if (startDate != null) {
      if (startDate.isAfter(endDate)) {
        showSnackbar("Etkinlik başlangıç tarihi bitiş tarihinden önce olmalı.");
        return "";
      }
    }
  }

  Future<void> _formSubmit() async {
    if (_eventFormKey.currentState.saveAndValidate()) {
      try {
        if (!checkEventHasImages()) {
          showSnackbar("En az 1 etkinlik fotoğrafı seçmelisin.");
        } else {
          var title =
              _eventFormKey.currentState.value['eventTitle'].toString().trim();
          DateTime startDate =
              _eventFormKey.currentState.value['eventStartDate'];
          DateTime endDate = _eventFormKey.currentState.value['eventEndDate'];
          var description = _eventFormKey.currentState.value['eventDescription']
              .toString()
              .trim();

          var location =
              isOnline ? null : _eventFormKey.currentState.value['location'];

          var mapLocation =
              isOnline ? "" : selectedPlace.geometry.location.toString();

          var address = isOnline ? null : selectedPlace.formattedAddress;

          var url = isOnline
              ? _eventFormKey.currentState.value['eventURL'].toString().trim()
              : null;
          var searchKeywords = createSearchKeywords(title);
          var category = widget.eventCategory;
          var eventType = widget.eventType;

          await createEvent(title, startDate, endDate, description, location,
              mapLocation, address, url, searchKeywords, category, eventType);
        }
      } catch (e) {
        logger.e("Form submit edilirken hata oluştu: $e ");
      }
    }
  }

  Future<void> createEvent(
      String title,
      DateTime startDate,
      DateTime endDate,
      String description,
      String location,
      String mapLocation,
      String address,
      String url,
      List<String> searchKeywords,
      String category,
      String eventType) async {
    try {
      CommonMethods().showLoaderDialog(context, "Etkinlik Oluşturuluyor.");
      EventModel newEvent = createEventModel(
          title,
          startDate,
          endDate,
          description,
          location,
          mapLocation,
          url,
          address,
          searchKeywords,
          category,
          eventType);

      await eventProvider.addEvent(newEvent, _eventImages).then((_) async {
        NavigationService.instance.pop();
        await CommonMethods().showSuccessDialog(
            context, "Tebrikler! Etkinliğin başarıyla yayınlandı.");
        NavigationService.instance.navigateToReset(k_ROUTE_HOME);
      });
    } catch (e) {
      print("EventCreationPage error $e ");
      print(e.toString());
      NavigationService.instance.pop();
      CommonMethods().showErrorDialog(context, "Etkinlik oluşturulamadı.");
    }
  }

  EventModel createEventModel(
      String title,
      DateTime startDate,
      DateTime endDate,
      String description,
      String location,
      String mapLocation,
      String address,
      String url,
      List<String> searchKeywords,
      String category,
      String eventType) {
    EventModel newEvent = EventModel(
      id: null,
      visible: true,
      title: title,
      description: description,
      city: location,
      isOnline: isOnline,
      creationDate: DateTime.now(),
      startDate: startDate,
      endDate: endDate,
      category: category,
      eventType: eventType,
      eventURL: url,
      isDone: false,
      ownerType: ownerType,
      ownerId: ownerId,
      locationCoordinates: mapLocation,
      address: address,
      searchKeywords: searchKeywords,
    );

    return newEvent;
  }

  bool checkEventHasImages() {
    if (_eventImages.length == 0) {
      return false;
    }
    return true;
  }

  showSnackbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  List<String> createSearchKeywords(String title) {
    List<String> searchKeywords = [];

    var splittedTitle = title.split(" ");
    splittedTitle.forEach((word) {
      searchKeywords.add(word.toLowerCase());
    });

    for (int i = 1; i <= title.length; i++) {
      searchKeywords.add(title.substring(0, i).toLowerCase());
    }
    return searchKeywords;
  }

  String getRandomEventTitle() {
    int randomNumber = Random().nextInt(2);

    List<String> titles = [
      "Beşiktaş Türkü Gecesi",
      "Eskişehir Dans Topluluğu Organizasyonu",
      "Kocaeli Heykel Sergisi"
    ];

    return titles[randomNumber];
  }

  Future<void> _selectFiles() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      //Seçilen fotoğrafları listeye ekliyoruz.
      var files = result.paths.map((path) {
        return File(path);
      }).toList();

      _eventImages.addAll(files);
      print("Fotoğraflar seçildi");
      setState(() {});
    } else {
      print("Fotoğraflar seçilmedi");
    }
  }

  removePickedFile(File file) {
    setState(() {
      _eventImages.remove(file);
    });
  }

  Future _showMapPicker() async {
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
                            // fontFamily: "Raleway",
                          ),
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
      logger.i("PickerResult değeri alındı:  " +
          selectedPlace.geometry.location.toString());
    } else {
      logger.e("PlacePicker result is null");
    }
  }
}
