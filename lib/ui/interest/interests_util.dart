class InterestType {
  String id;
  String name;
  String coverPhotoUrl;
  List<String> subCategories;

  InterestType(
      {String id,
      String name,
      String coverPhotoUrl,
      List<String> subCategories}) {
    this.id = id;
    this.name = name;
    this.coverPhotoUrl = coverPhotoUrl;
    this.subCategories = subCategories;
  }
}

List<InterestType> interestCategoryList = [
  new InterestType(
      id: "0",
      name: "Tiyatro",
      coverPhotoUrl: "assets/images/app/interests/tiyatro.jpeg",
      subCategories: [
        'Operet',
        'Skeç',
        'Opera',
        'Fars',
        'Melodram',
        'Feeri',
        'Pandomim',
        'Drama',
        'Komedi'
      ]),
  new InterestType(
      id: "1",
      name: "Müzik",
      coverPhotoUrl: "assets/images/app/interests/muzik.jpeg",
      subCategories: [
        'Enstrümantal',
        'Klasik',
        'Elektronik',
        'Halk',
        'Jazz',
        'Pop',
        'Rock',
        'asasd'
      ]),
  new InterestType(
      id: "2",
      name: "Dans",
      coverPhotoUrl: "assets/images/app/interests/dans.jpeg",
      subCategories: [
        'Bale',
        'Ça-ça',
        'Halk Oyunları',
        'Hip Hop',
        'Salsa',
        'Modern Dans',
        'Samba',
        'Zumba',
        'Zeybek',
        'Oryantal',
        'Roman',
        'Tango'
      ]),
  new InterestType(
      id: "3",
      name: "Görsel Sanatlar",
      coverPhotoUrl: "assets/images/app/interests/gorsel_sanatlar.jpeg",
      subCategories: [
        'Seramik',
        'Heykel',
        'Fotoğrafçılık',
        'Graffiti',
        'Karikatür',
        'İllustrasyon',
        'Manga',
        'Anime',
        'Animasyon',
        'Portre',
        'Çini',
        'Karakalem',
        'Ebru'
      ])
];
