import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EventEditPage extends StatefulWidget {
  EventModel event;
  EventEditPage({this.event});

  @override
  _EventEditPageState createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  GlobalKey<FormBuilderState> _eventFormKey = new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _eventScaffoldKey = GlobalKey<ScaffoldState>();
  var logger = Logger();
  EventProvider eventProvider;
  EventModel event;

  TextEditingController _eventLocationController = new TextEditingController();

  FocusNode eventTitleFocus = new FocusNode();
  FocusNode eventDescriptionFocus = new FocusNode();
  FocusNode eventURLFocus = new FocusNode();
  FocusNode checkboxFocus = new FocusNode();
  FocusNode dropdownFocus = FocusNode();

  DateTime eventStartDate;
  DateTime eventEndDate;
  PickResult selectedPlace;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventStartDate = event.startDate;
    eventEndDate = event.endDate;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _formSubmit,
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Etkinlik Düzenle'),
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
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  buildFormPart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildFormPart() {
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
                  initialValue: event.title,
                  name: "eventTitle",
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      border: InputBorder.none,
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
                      format: DateFormat("dd/MM/yyyy hh:mm", "tr_TR"),
                      locale: Locale("tr", "TR"),
                      alwaysUse24HourFormat: true,

                      name: "eventStartDate",
                      decoration: InputDecoration(
                        border: InputBorder.none,

                        // border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        eventStartDate = value;
                      },
                      initialValue: eventStartDate,
                      confirmText: "Tamam",
                      initialDate: eventStartDate,
                      firstDate: eventStartDate,
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
                      format: DateFormat("dd/MM/yyyy hh:mm", "tr_TR"),
                      locale: Locale("tr", "TR"),
                      alwaysUse24HourFormat: true,
                      name: "eventEndDate",
                      cancelText: "İptal",
                      confirmText: "Tamam", fieldLabelText: 'Bitiş tarihi',
                      fieldHintText: 'Gün/Ay/Yıl',
                      // timePickerInitialEntryMode: TimePickerEntryMode.input,
                      initialValue: eventEndDate,
                      initialDate: eventEndDate,
                      firstDate: eventEndDate,
                      decoration: InputDecoration(
                        border: InputBorder.none,

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
                  // textInputAction: TextInputAction.,
                  focusNode: eventDescriptionFocus,
                  name: "eventDescription",
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: kPrimaryColor,
                  maxLines: null,
                  initialValue: event.description,
                  decoration: InputDecoration(
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
          event.isOnline
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
                        initialValue: event.eventURL,
                        decoration: InputDecoration(
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
                            FormBuilderValidators.url(context,
                                errorText: "Lütfen geçerli bir URL gir."),
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
                              initialValue: event.city,
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
                                    : event.address,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.location_on),
                                    errorStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .errorStyle),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
          //dvem
          SizedBox(height: 10),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text("Fotoğraflar",
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //     SizedBox(height: 4),
          //     Container(
          //       width: size.width * 0.9,
          //       height: 100,
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: _eventImages.length + 1,
          //         padding: EdgeInsets.only(right: 8),
          //         itemBuilder: (context, index) {
          //           if (_eventImages.length == 0) {
          //             return GestureDetector(
          //               onTap: _selectFiles,
          //               child: Container(
          //                 height: size.height * 0.1,
          //                 width: size.width * 0.25,
          //                 child: Card(
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                     child:
          //                         Icon(Icons.camera_alt, color: Colors.grey)),
          //               ),
          //             );
          //           } else {
          //             if (index == 0) {
          //               return GestureDetector(
          //                 onTap: _selectFiles,
          //                 child: Container(
          //                     height: size.height * 0.1,
          //                     width: size.width * 0.25,
          //                     child: Card(
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(10),
          //                         ),
          //                         child: Icon(Icons.camera_alt,
          //                             color: Colors.grey))),
          //               );
          //             }
          //             var image = _eventImages[index - 1];
          //             return Stack(
          //               children: [
          //                 Container(
          //                   height: 100,
          //                   width: size.width * 0.25,
          //                   child: Card(
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                     clipBehavior: Clip.antiAlias,
          //                     child: Image.file(
          //                       image,
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                   right: 1,
          //                   child: CircleAvatar(
          //                     backgroundColor: Colors.white,
          //                     radius: 13,
          //                     child: IconButton(
          //                         padding: EdgeInsets.zero,
          //                         onPressed: () {
          //                           removePickedFile(image);
          //                         },
          //                         icon: Icon(
          //                           Icons.clear,
          //                           color: Colors.grey,
          //                           size: 20,
          //                         )),
          //                   ),
          //                 )
          //               ],
          //             );
          //           }
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  checkDateRange(DateTime endDate) {
    if (eventStartDate != null) {
      if (eventStartDate.isAfter(endDate)) {
        showSnackbar("Etkinlik başlangıç tarihi bitiş tarihinden önce olmalı.");
        return "";
      }
    }
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  Future<void> _formSubmit() async {
    if (_eventFormKey.currentState.saveAndValidate()) {
      try {
        var title =
            _eventFormKey.currentState.value['eventTitle'].toString().trim();
        DateTime startDate = _eventFormKey.currentState.value['eventStartDate'];
        DateTime endDate = _eventFormKey.currentState.value['eventEndDate'];
        var description = _eventFormKey.currentState.value['eventDescription']
            .toString()
            .trim();

        var location = event.isOnline
            ? null
            : _eventFormKey.currentState.value['location'];

        var mapLocation = event.isOnline
            ? ""
            : selectedPlace != null
                ? selectedPlace.geometry.location.toString()
                : event.locationCoordinates;

        var address = event.isOnline
            ? null
            : selectedPlace != null
                ? selectedPlace.formattedAddress.toString()
                : event.address;

        var url = event.isOnline
            ? _eventFormKey.currentState.value['eventURL'].toString().trim()
            : null;
        var searchKeywords = createSearchKeywords(title);
        updateEvent(title, startDate, endDate, description, location,
            mapLocation, address, url, searchKeywords);
      } catch (e) {
        logger.e("Form submit edilirken hata oluştu: $e ");
      }
    }
  }

  Future updateEvent(
      String title,
      DateTime startDate,
      DateTime endDate,
      String description,
      String location,
      String mapLocation,
      String address,
      String url,
      List<String> searchKeywords) async {
    try {
      CommonMethods().showLoaderDialog(context, "Etkinlik Oluşturuluyor");
      eventProvider.update(event.id, {
        'title': title,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
        'city': location,
        'locationCoordinates': mapLocation,
        'address': address,
        'eventURL': url,
        'searchKeywords': searchKeywords,
      }).then((value) async {
        NavigationService.instance.pop();
        await CommonMethods()
            .showSuccessDialog(context, "Etkinlik başarıyla düzenlendi.");
        NavigationService.instance.navigateToReset(k_ROUTE_HOME);
      });
    } catch (e) {
      print("EventEditPage error $e ");
      print(e.toString());
      NavigationService.instance.pop();
      CommonMethods().showErrorDialog(context, "Etkinlik düzenlenemedi.");
    }
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
                        backgroundColor: kNavbarColor,
                        onPressed: () {
                          Navigator.of(context).pop(selectedPlace);
                        },
                        child: Text(
                          "Seç",
                          style: TextStyle(
                            color: Colors.white,
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
