import 'dart:io';

import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EventCreationPage extends StatefulWidget {
  final String eventCategory;
  final String eventType;
  final String eventPlatform;
  final String groupId;

  EventCreationPage(
      {this.eventCategory, this.eventType, this.eventPlatform, this.groupId});

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends BaseState<EventCreationPage> {
  List<File> _eventImages = [];
  String eventCoordinates;
  String eventCity;

  EventProvider eventProvider;

  GlobalKey<FormBuilderState> _formKey = new GlobalKey<FormBuilderState>();

  TextEditingController _eventLocationController = new TextEditingController();

  FocusNode eventTitleFocus = new FocusNode();
  FocusNode eventDescriptionFocus = new FocusNode();
  FocusNode eventURLFocus = new FocusNode();
  FocusNode checkboxFocus = new FocusNode();
  FocusNode dropdownFocus = FocusNode();

  bool isHelpChecked = false;
  bool isAdWatched = false;
  bool isRewardedAdReady = false;
  String chosenCompany;
  RewardedAd rewardedAd;

  DateTime _eventStartDate = new DateTime.now();
  DateTime _eventEndDate = new DateTime.now().add(Duration(days: 1));
  bool isOnline;
  String postOwnerType;
  String ownerGroupId;

  PickResult selectedPlace;

  var logger = Logger();

  @override
  void dispose() {
    super.dispose();
    eventDescriptionFocus.dispose();
    eventTitleFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    prepareAd();
    eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.clearNewEvent();
    isOnline = widget.eventPlatform == 'Online Etkinlik' ? true : false;

    widget.groupId != null
        ? Logger().i(
            "Grup için etkinlik oluşturma aşaması başladı: ${widget.groupId}")
        : null;
    postOwnerType = widget.groupId == null ? "User" : "Group";
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
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
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
    if (_eventImages.length == 0) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Etkinlik Adı",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  focusNode: eventTitleFocus,
                  name: "eventTitle",
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
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                      (value) {
                        return ProfanityChecker.profanityValidator(value);
                      },
                      FormBuilderValidators.minLength(context, 20,
                          errorText: "Etkinlik başlığı en az 10 harf olmalı.",
                          allowEmpty: false)
                    ],
                  ),
                ),
              ),
              Text("Etkinlik Açıklaması",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                  focusNode: eventDescriptionFocus,
                  name: "eventDescription",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
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
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                      (value) {
                        return ProfanityChecker.profanityValidator(value);
                      },
                      FormBuilderValidators.minLength(context, 20,
                          errorText:
                              "Biraz daha detay verilmeli (En az 50 harf).",
                          allowEmpty: false)
                    ],
                  ),
                ),
              ),
              Text("Etkinlik Başlangıç Tarihi",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFieldContainer(
                key: Key(DateFormat("dd/mm/yyyy").format(_eventStartDate)),
                width: size.width * 0.6,
                child: FormBuilderDateTimePicker(
                  format: DateFormat("dd/MM/yyyy hh:mm"),
                  onChanged: (date) {
                    if (date != null) {
                      setState(() {
                        _eventStartDate = date;
                      });
                    }
                  },
                  initialDate: _eventEndDate ?? null,
                  alwaysUse24HourFormat: true,
                  name: "eventStartDate",
                  decoration: InputDecoration(
                    hintText:
                        DateFormat("dd/MM/yyyy hh:mm").format(_eventStartDate),
                    icon: Icon(
                      FontAwesome5Solid.calendar,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                  ),
                  confirmText: "Tamam",
                  cancelText: "İptal",
                  fieldLabelText: "Etkinlik Başlangıç Tarihi",
                  helpText: "Bir başlangıç tarihi seç",
                  fieldHintText: "Gün/Ay/Yıl",
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(context,
                  //       errorText: "Bir başlangıç tarihi seçmelisin"),
                  // ]),
                  firstDate: DateTime.now(),
                ),
              ),
              Text("Etkinlik Bitiş Tarihi",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFieldContainer(
                key: Key(DateFormat("dd/mm/yyyy").format(_eventEndDate)),
                width: size.width * 0.6,
                child: FormBuilderDateTimePicker(
                  helpText: "Bir bitiş tarihi seç",
                  format: DateFormat("dd/MM/yyyy hh:mm"),
                  onChanged: (date) {
                    if (date != null) {
                      setState(() {
                        _eventEndDate = date;
                      });
                    }
                  },
                  initialDate: _eventEndDate ?? null,
                  alwaysUse24HourFormat: true,
                  name: "eventEndDate",
                  firstDate: _eventStartDate,
                  decoration: InputDecoration(
                    hintText:
                        DateFormat("dd/MM/yyyy hh:mm").format(_eventEndDate),
                    icon: Icon(
                      FontAwesome5Solid.calendar,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                  ),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(context,
                  //       errorText: "Bir tarih seçmelisin.")
                  // ]),
                ),
              ),
              isOnline
                  ? Column(
                      children: [
                        Text("Etkinlik Adresi",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        TextFieldContainer(
                          width: size.width * 0.6,
                          child: FormBuilderTextField(
                            textInputAction: TextInputAction.next,
                            focusNode: eventURLFocus,
                            name: "eventURL",
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Bu alan boş bırakılamaz.",
                                ),
                                (value) {
                                  return ProfanityChecker.profanityValidator(
                                      value);
                                },
                                FormBuilderValidators.url(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Etkinlik Yapılacak Şehir",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: size.width * 0.6,
                          child: FormBuilderDropdown(
                            focusNode: dropdownFocus,
                            hint: Text("Şehir Seçin"),
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            name: "location",
                            items: cities
                                .map((city) => DropdownMenuItem(
                                      value: city,
                                      child: Text('$city'),
                                    ))
                                .toList(),
                          ),
                        ),
                        Text("Etkinlik Lokasyonu",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        //TODO: Picker ı değiştir.
                        Row(
                          children: [
                            TextFieldContainer(
                              width: size.width * 0.6,
                              child: FormBuilderTextField(
                                key: selectedPlace != null
                                    ? Key(selectedPlace.formattedAddress)
                                    : null,
                                readOnly: true,
                                name: "eventLocation",
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                cursorColor: kPrimaryColor,
                                initialValue: selectedPlace != null
                                    ? selectedPlace.formattedAddress
                                    : "",
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
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(context,
                                        errorText: "Bu alan boş bırakılamaz.")
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await _showMapPicker();
                                },
                                icon: Icon(Icons.location_on)),
                          ],
                        ),
                      ],
                    ),
              TextFieldContainer(
                child: FormBuilderCheckbox(
                  focusNode: checkboxFocus,
                  name: "donation",
                  initialValue: isHelpChecked,
                  title: Text(
                    "Bu paylaşımım ile kurumlara yardım etmek istiyorum",
                  ),
                  onChanged: (value) async {
                    if (value == true) {
                      print(chosenCompany);
                      await makeContribution();

                      if (chosenCompany != null) {
                        setState(() {
                          isHelpChecked = value;
                        });
                      } else {
                        setState(() {
                          isHelpChecked = !value;
                        });
                      }
                    } else {
                      chosenCompany = null;

                      setState(() {
                        isHelpChecked = value;
                      });
                    }
                  },
                ),
              )
            ],
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
      logger.i("PickerResult değeri alındı:  " +
          selectedPlace.geometry.location.toString());
    } else {
      logger.e("PlacePicker result is null");
    }
  }

  Future<void> _formSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      try {
        var imageCheck = checkEventHasImages();
        if (imageCheck == false) {
          await CommonMethods()
              .showErrorDialog(context, "En az 1 fotoğraf seçmelisin");
        } else {
          if (chosenCompany != null) {
            Logger().i("Şirket seçildi");
            await rewardedAd.show(
                onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
              isAdWatched = true;
              Logger().i("Reklam ödülü verildi");
            }).then((value) async {
              Logger().i("Reklam izlendi");
              await createEvent(isUsedForHelp: true);
            });
          } else {
            Logger().i("Şirket seçilmedi");
            await createEvent(isUsedForHelp: false);
          }
        }
      } catch (e) {
        Logger().e("Form submit edilirken hata oluştu: " + e.toString());
      }
    }
  }

  Future<void> createEvent({bool isUsedForHelp}) async {
    try {
      CommonMethods().showLoaderDialog(context, "Etkinlik oluşturuluyor.");
      setNewEventValues(isUsedForHelp: isUsedForHelp);

      await eventProvider.addEvent(_eventImages).then((_) async {
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

  List<String> createSearchKeywords(EventModel event) {
    List<String> searchKeywords = [];

    var title = event.eventTitle;

    var splittedTitle = title.split(" ");
    splittedTitle.forEach((word) {
      searchKeywords.add(word.toLowerCase());
    });

    for (int i = 1; i <= title.length; i++) {
      searchKeywords.add(title.substring(0, i).toLowerCase());
    }
    return searchKeywords;
  }

  void setNewEventValues({bool isUsedForHelp}) {
    eventProvider.newEvent.visible = true;
    eventProvider.newEvent.eventId = "";
    eventProvider.newEvent.eventTitle =
        _formKey.currentState.value['eventTitle'].toString().trim();

    eventProvider.newEvent.searchKeywords =
        createSearchKeywords(eventProvider.newEvent);

    eventProvider.newEvent.eventDescription =
        _formKey.currentState.value['eventDescription'].toString().trim();

    //TODO: Start Date ve End Date farkını ayarla

    eventProvider.newEvent.eventCreationDate = DateTime.now();
    eventProvider.newEvent.eventStartDate = _eventStartDate;
    eventProvider.newEvent.eventEndDate = _eventEndDate;
    eventProvider.newEvent.isDone = false;
    eventProvider.newEvent.isOnline = isOnline;
    eventProvider.newEvent.eventURL = isOnline
        ? _formKey.currentState.value['eventURL'].toString().trim()
        : "";

    eventProvider.newEvent.eventLocationCoordinates =
        isOnline ? "" : selectedPlace.geometry.location.toString();

    if (postOwnerType == "User") {
      eventProvider.newEvent.ownerId = authProvider.currentUser.uid;
      eventProvider.newEvent.ownerType = "User";
    } else if (postOwnerType == "Group") {
      eventProvider.newEvent.ownerId = widget.groupId;
      eventProvider.newEvent.ownerType = "Group";
    }

    eventProvider.newEvent.city =
        _formKey.currentState.value['location'].toString().trim();
    eventProvider.newEvent.eventCategory = widget.eventCategory;
    eventProvider.newEvent.eventType = widget.eventType;

    if (isUsedForHelp) {
      eventProvider.newEvent.isUsedForHelp = true;
    } else {
      eventProvider.newEvent.isUsedForHelp = false;
    }
  }

  Future<void> makeContribution() async {
    var contributionDialog = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => contributionCategoryDialog(context),
    );

    if (contributionDialog != null) {
      print(contributionDialog);
      chosenCompany = contributionDialog;
    }
  }

  Future prepareAd() async {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                isRewardedAdReady = false;
              });
              prepareAd();
            },
          );

          setState(() {
            isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  bool checkEventHasImages() {
    if (_eventImages.length == 0) {
      return false;
    }
    return true;
  }
  //TODO: UPLOAD EDİLDİKTEN SONRA GEÇİCİ DOSYALAR SİLİNMELİ
}
